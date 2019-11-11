(**
  ## 変数と関数

  この章では 変数及び関数へのアプローチと、引数（ラベル付き引数）へのアプローチを説明する。
*)

(* In repl, `#require "base"` *)
open Base


(* let <variable> = <value> *)
let x = 3
(** output:
  val x : int = 3
*)
let y = 4
let x = x + y
(** output:
  val y : int = 4
  val x : int = 7
*)


let lang = "Programing languages: OCaml,Haskell,Rust"
(** output:
  val lang : string = "Programing languages: OCaml,Haskell,Rust"
*)

(* let/in式を利用することで、より大きな計算や込み入った変数を定義できる *)
(* 下記の構文では、最初にexpr1が評価され、次にexpr2が評価される *)
(* let <variable> = <expr1> in <expr2> *)
let lang = 
  let header = "Programming languages: " in
  let ocaml =  "OCaml," in
  let haskell = "Haskell," in
  let rust = "Rust" in
  header ^ ocaml ^ haskell ^ rust
(* "^" は文字列を結合するための演算子 *)

(* letでパターンマッチング *)
(**
  (ints, strings) はタプルでありかつパターンというものであり（タプルパターン）、
  letはList.unzip の結果を ints, strings のそれぞれに振り分けている。
*)
let (ints, strings) = List.unzip [(1, "one"); (2, "two"); (3, "three")]
(** output
  val ints : int list = [1; 2; 3]
  val strings : string list = ["one"; "two"; "three"]
*)

(**
  letパターンマッチングは パターンのそれぞれの型が全て同じことを保証する。
  タプルでは型が同一であることが保証されるが、リストでは方が同一かどうかの保証が得られない。
*)

(* 以下のコードは、最初の要素を大文字に変更するという関数を定義したもの *)
let upcase_first_entry line = 
  (**
    これがリストパターンマッチングであり、
    下記のコード (first :: rest) の意味は、
    (先頭要素 :: 残りのリスト) という形であり、つまり (string型 :: string型) である。
  *)
  (* String.split の 先頭にチルダ~がついた引数 on については後述するので気にしなくてよい *)
  let (first :: rest) = String.split ~on:',' line in
  String.concat ~sep:"," (String.uppercase first :: rest)
  (**
    しかしコンパイラは空文字""の場合は、パターンにマッチしないという警告を出す。
    しかしながら、String.split は空文字であっても正常に処理するような実装となっている。
    そのため上記のコードでも問題なく動作する。
   *)
  
(** 実行例:
  upcase_first_entry "one,two,three";;
  - : string = "ONE,two,three"  
*) 

(* 一般的には matchステートメントを利用して空文字の場合を処理するようなコードを明示する *)
let upcase_first_entry line = 
  match String.split ~on:',' line with
  | [] -> ""
  | first :: rest -> String.concat ~sep:"," (String.uppercase first :: rest)
(* コンパイル時に警告が出ないことを確認できる *)
(** 実行例:
  upcase_first_entry "";;
  - : string = ""
*)

(* OCamlの関数 *)

(* fun は無名関数または匿名関数を宣言するためのもの *)
(fun x -> x + 1)
(** output:
  - : int -> int = <fun>
*)
(fun x -> x + 1) 7
(** output:
  - : int = 8
*)

(**
  無名関数の一般的な利用方法として、
  関数を引数にとる関数（以下の例ではList.map）で利用することがある。
*)
(* ~f: は 関数を引数にとることを示す *)
List.map ~f:(fun x -> x + 1) [1;2;3]
(** output:
  - : int list = [2; 3; 4]
*)

(**
  脇道に逸れるレベルのお話なので、飛ばしても良いかも。
  以下の例は、高階関数の例であり、高階関数とは、
  関数の引数や戻り値に関数を利用した関数を指す。

  まず、~f:(fun g -> g "Hello World") は、gという関数を受け取って、
  その関数の引数として"Hello World"を与えるというもの。

  後ろのtransformsは、文字列を引数として受け取る関数を配列にしたもの。

  List.map は transforms の要素を展開し、それを ~fの g として適用する、
  つまり、
  - String.uppercase "Hello World"
  - String.lowercase "Hello World"
  が実行される。
*)
let transforms = [ String.uppercase; String.lowercase ]
List.map ~f:(fun g -> g "Hello World") transforms
(** output:
  - : string list = ["HELLO WORLD"; "hello world"]
*)

(* let と fun の関係 *)
(* 以下の2つは同じ意味となる *)
(fun x -> x +1) 7
let x = 7 in x + 1
(* モナドを利用する際に必要となるので気にかけておきたいが、そもそもモナド不要かも *)

(* 複数の引数をとる場合、以下の2通りの書きかたできる *)
(* 下記は2つの引数の差を絶対値として出力する関数 *)
let abs_diff x y = abs (x - y)
let abs_diff = (fun x -> (fun y -> abs (x - y)))
(** output:
  val abs_diff : int -> int -> int = <fun>
*)

(* fun はカリー化をサポートしているため、以下のようにもかける *)
let abs_diff = (fun x y -> abs (x - y))
(** output:
  val abs_diff : int -> int -> int = <fun>
*)

(* 一般的にカリー化はコストが高いらしいが、OCamlではその心配はいらない *)
(* ただし部分適用にはいくつかのコストがかかる *)
(* カリー化と部分適用をしっかり区別すること *)


(* 再帰関数 *)
(**
  再帰関数を定義する際には、
  let の後ろに recキーワードをおくことで、それが再起関数だと宣言する。
*)

let rec find_first_repeat list = 
  match list with
  | [] | [_] -> None (* or パターン *)
  | x :: y :: tl ->
     if x = y then Some x else find_first_repeat (Y::tl)

(* [_] は配列の長さ1の場合を表す *)
(* _ は任意の、つまりどんな値でも良いという意味 *)

(* prefixスタイルとinfixスタイル *)
Int.max 3 4 (* prefix *)
3 + 4 (* infix *)

(* 中置演算子はカッコ()で囲むとprefixスタイルのように記述できる *)
(+) 3 4
(* 実際の利用例 *)
List.map ~f:((+) 3) [4; 5; 6;]

(* OCaml では演算子を再定義することも可能 *)

(**
  ただし、以下のように "*" を含む演算子を定義する場合は
  コメントとして解釈されないように、
  "( *** )"のようにスペースを開けておくこと
*)

(** NG 
  let (***) x y = (x **. y) **. y
*)
let ( *** ) x y = (x **. y) **. y

(* OCaml での負の数の扱い *)
Int.max 3 (-4)
(* カッコで囲む必要がある *)
(** NG
  Int.max 3 -4

  output:
  Error: This expression has type int -> int
         but an expression was expected of type int
*)
(** これは以下のように解釈されている 
  (Int.max 3) - 4
*)

(* 次の演算子は関数と引数の順序を逆に受け取るもの *)
(* 具体的には Shellのパイプのように利用することができる *)
(** ouput:
  (|>) ;;
  - : 'a -> ('a -> 'b) -> 'b = <fun>
*)


(* 環境変数PATHから全てのパスを列挙する関数を考えてみる *)
(* In repl, `#require "stdio"` *)
open Stdio
let path = "/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin"
String.split ~on:':' path
|> List.dedup_and_sort ~compare:String.compare
|> List.iter ~f:print_endline
(** output:
  /usr/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/sbin
  - : unit = ()
*)

(* 仮に `|>` を利用しなかった場合 *)
let split_path = String.split ~on:':' path in
let deduped_path = List.dedup_and_sort ~compare:String.compare split_path in
List.iter ~f:print_endline deduped_path

(* `|>` は左結合演算子であったから上手く行っている *)
(**
  なぜ `|>` が左結合演算子かというと、オペレータープレフィックスというのがあり、
  OCamlでは `|` も `>` も左結合演算子で定義されているから。
*)
(* `^>` のような右結合演算子を利用した場合はどのようになるか見ていく *)
(* `^` は右結合演算子であることに注意 *)

(** error:
  let (^>) x f = f x
  String.split ~on:':' path
  ^> List.dedup_and_sort ~compare:String.compare
  ^> List.iter ~f:print_endline

  Error: This expression has type string list -> unit
         but an expression was expected of type
           (string list -> string list) -> 'a
         Type string list is not compatible with type string list -> string list
*)
(**
   オペレーターの結合性について知っておかないと、
   エラーメッセージだけでは読み取るのは難しいかもしれない
*)

(* 関数宣言 function キーワード *)
(* 関数を宣言する際には function キーワードを利用する *)
let some_or_default default = function
  | Some x -> x
  | None -> default

some_or_default 3 (Some 5)
(** output:
  - : int = 5
*)
some_or_default 3 None
(** output:
  - : int = 3
*)

(* ラベル引数 *)
(* 引数に名前をつけることで、引数の順序を考えなくてもよくなる手法 *)

let ratio ~num ~denom = Float.of_int num /. Float.of_int denom
ratio 3 10
(** output:
  - : float = 0.3
*)

(**
  ラベル付き引数の利点
  - 引数の位置でなく名前に意味を持たせることができる
  - (ただし位置について高階関数の場合は注意が必要)
  - 引数の型を推測しやすくなる
*)

(* 下記は同じ結果となる *)
ratio 3 10
ratio ~num:3 ~denom:10
ratio ~denom:10 ~num:3
(** output:
  - : float = 0.3
*)

(* 高階関数のラベル *)
(**
  高階関数におけるラベルの扱いは注意が必要。
  ラベル付き引数を高階関数に渡す場合は、引数の順序を同じにしなければいけない。
*)
let apply_to_tuple f (first, second) = f ~first ~second
let apply_to_tuple2 f (first, second) = f ~second ~first
(* apply_to_tuple2 は位置が合わないためエラーとなる *)

(* 例 *)
apply_to_tuple (fun ~first ~second -> first / second) (3,4)
(** output:
  - : int = 0
*)

(**
  apply_to_tuple2 では second,firstの順でfに適用するよう定義されているが、
  f は first second の順で引数を受け取るようになっているためエラーとなる。
*)
apply_to_tuple2 (fun ~first ~second -> first / second) (3,4)
(** output:
  Error: This function should have type second:'a -> first:'b -> 'c
         but its first argument is labelled ~first
*)


(* オプショナル引数 *)
(* オプショナル引数は他のプログラミング言語でいうデフォルト値のように利用できる *)
(* つまり関数呼び出しの際に必ずしも引数として与えなくてもよい引数だ *)

let concat ?sep x y = 
  let sep = match sep with None -> "" | Some x -> x in
  x ^ sep ^ y

concat "foo" "bar"
(** output:
  - : string = "foobar"
*)

concat ~sep:"---" "foo" "bar"
(** output:
  - : string = "foo---bar"
*)

(* オプショナル引数にデフォルト値を設けたい場合は以下のようにする *)
let concat ?(sep="") x y = x ^ sep ^ y
concat "foo" "bar"
(** output:
  - : string = "foobar"
*)
concat ~sep:"---" "foo" "bar"
(* 結果は上と同じため割愛 *)

(* 明示的に Some や None を渡す場合は `~`ではなく、 ~?~を利用する *)
concat "foo" "bar"
concat ?sep:None "foo" "bar"
concat ~sep:"---" "foo" "bar"
concat ?sep:(Some "---") "foo" "bar"

(* ラベル付き引数とオプショナル引数の型推論 *)

(* 下記の例をながめる *)
let number_deriv ~delta ~x ~y ~f =
  let x' = x +. delta in (* OCamlでは変数に `'`を用いることができる *)
  let y' = y +. delta in
  (**
    fはラベル付き引数をとるため y:float -> x:float -> float
    または
    x:float -> y:float -> float
    をとることができる
  *)
  let base = f ~x ~y in 
  let dx = (f ~x:x' ~y -. base) /. delta in
  let dy = (f ~x ~y:y' -. base) /. delta in
  (dx,dy)

(* 一方で、fがオプショナル付き引数をとると解釈する場合もある *)
(* コンパイラでは、オプショナル引数よりもラベル引数を優先する *)

(* たとえば、引数の順番を入れ替えるとコンパイラは解釈できずエラーとなる *)
let number_deriv ~delta ~x ~y ~f = 
  let x' = x +. delta in
  let y' = y +. delta in
  let base = f ~x ~y in
  let dx = (f ~y ~x:x' -. base) /. delta in
  let dy = (f ~x ~y:y' -. base) /. delta in
  (dx,dy)
(** ouput:
  Error: This function is applied to arguments
         in an order different from other calls.
         This is only allowed when the real type is known.
*)

(* しかし、fに型アノテーションを用いることでエラーなく実装できる *)
let number_deriv ~delta ~x ~y ~(f: x:float -> y:float -> float) = 
  let x' = x +. delta in
  let y' = y +. delta in
  let base = f ~x ~y in
  let dx = (f ~y ~x:x' -. base) /. delta in
  let dy = (f ~x ~y:y' -. base) /. delta in
  (dx,dy)

(* オプショナル引数と部分適用について *)

(* 以下のとおり、オプショナル引数を持つ関数をラップする *)
let colon_concat = concat ~sep:":"
colon_concat "a" "b"

(* concatを部分適用したものをラップするとどうなるか *)
let prepend_pound = concat "# "
prepend_pound "a BASH comment"

(* オプショナル引数を与えようとするとどうなるか *)
prepend_pound "a BASH comment" ~sep:":"
(** output:
  Error: This function has type string -> string
         It is applied to too many arguments; maybe you forgot a `;'.
*)


(* 理由は、オプショナル引数の後に定義された引数が渡された場合、それよりも前の位置にあるオプショナル引数は削除されるためだ *)
(* つまりオプショナル引数を2番目以降に定義すればこの問題は解決できる *)
let concat x ?(sep="") y = x ^ sep ^ y
let prepend_pound = concat "# " ~sep:"--- "
prepend_pound "a BASH comment"

(* ただし、一番最後にオプショナル引数を置いた場合は、オプショナル引数の省略ができない *)
let concat x y ?(sep="") = x ^ sep ^ y
(* 下記はオプショナル引数を省略できないことを示している *)
(** output:
  Warning 16: this optional argument cannot be erased.
  val concat : string -> string -> ?sep:string -> string = <fun>
*)

concat "a" "b"
(* sepが省略されず、必ず付けなければいけないことがわかる *)
(** output:
  - : ?sep:string -> string = <fun>
*)
