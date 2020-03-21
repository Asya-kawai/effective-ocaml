(**
  ## リストとパターンマッチ

  この章ではOCamlでも重要なリストとパターンマッチについて説明する。
*)

(* In repl, `#require "base"` *)
open Base

let l = [1;2;3;]
(** output:
  val l : int list = [1; 2; 3]
*)

(* Listは `::` オペレータを用いて生成することもできる *)
let l = 1 :: (2 :: (3 :: []))
(** output:
  val l : int list = [1; 2; 3]
*)

(* 以下のコードは上記と同じ結果となる *)
let l = 1 :: 2 :: 3 :: []

(**
  上記の例からも分かる通り、`::` は 右結合となっている。
  つまり `()` を省略して結合することができる。  

  お作法的に空リスト `[]` はリストの終端として利用できる。
  `[]` は様々な型を取りうることができることに留意する。
  （つまりどのような型のリストにも利用できる）。
*)

let empty = []
let n_list = 3 :: empty
let s_list = "three" :: empty

(* empty が任意の型を受け取れていることがわかる *)


(* matchステートメントの利用 *)

(**
  matchステートメントを利用して、リストから値を1つずつ取り出すことができる。
  matchステートメントは、
  ```
  match pattern with
  | expr -> ...  
  ```
  の形をとる。
*)

(* 引数にリストをとり、その合計を出力する sum 関数を定義してみる *)
let rec sum num_list = 
  match num_list with
  | [] -> 0
  | hd :: tl -> hd + (sum tl)
(** output:
  val sum : int list -> int = <fun>
*)

(**
  sum は num_list を引数にとり、要素の合計を算出する関数であることがわかる。

  というのも、受け取ったリストと hd と tl に分解し（パターンマッチ）、
  取り出した hd を加算していくため。
*)

(**
  matchステートメントは2つの機能を有している。

  * switch/caseのようなパターンマッチのための利用
  * データ構造の分解

  hd :: tl のような場合は、丁度データ構造の分解にあたる。
  また、直感的なので説明は不要かとおもうが、hd や tl は 変数として利用できる。
*)

(**
  matchステートメントを利用した、よくある間違いは以下のようなもの。
  例えば、リストを受け取り、その要素からある値を削除する関数を考えてみる。
*)

let rec drop_value l v =
  match l with
  | [] -> []
  | v :: tl -> drop_value tl v
  | hd :: tl -> hd :: (drop_value tl v)
(** output:
  Line 5, characters 7-15:
  Warning 11: this match case is unused.
  val drop_value : 'a list -> 'a -> 'a list = <fun>
*)

(**
  実際に試してみるとわかるが、これはどのような値を入力しても空リストが返却される。

  drop_value [1;2;3] 2 ;;
  - : int list = []
*)


(** なぜこのようなことが起きるか

  それは、2番目のパターンマッチである `v :: tl` が引数の v と一致しないためである。
  そのため、3番目のパターンは永遠に適用されることはなく、常に2番目のパターンマッチが適用される。

  その結果、`[]` が返却される。
*)

(* これを回避するには、以下のように実装する必要がある 
   ※参考にしたページと異なる実装としていることに留意。
*)
let rec drop_value l v =
  match l with
  | [] -> []
  | hd :: tl -> 
    if hd = v then drop_value tl v
    else hd :: (drop_value tl v)
(** output:
  val drop_value : 'a list -> 'a -> 'a list = <fun>
*)

(**
  実際に対象の値がdrop できているか試してみる。

  drop_value [1;2;3;] 2 ;;
  - : int list = [1; 3]   
*)

(* 特定のリテラル（文字）にマッチさせたい場合は、以下のように定義できる *)
let rec drop_zero l =
  match l with
  | [] -> []
  | 0 :: tl -> drop_zero tl
  | hd :: tl -> hd :: (drop_zero tl)
(** output
  val drop_zero : int list -> int list = <fun>
*)


(* ここからはListライブラリの使い方を解説した箇所が多いため割愛する *)

(** 末尾再帰について
  再帰は一見便利だが、そのコストを考えずに実施すると非効率なコードになってしまう
*)

let rec length = function
  | [] -> 0
  | _ :: tl -> 1 + (length tl)
(** output
  val length : 'a list -> int = <fun>
*)
(** この関数を実行した結果は以下のとおり
  
  length [1;2;3]
  - : int = 3
*)

(* 問題なく動作しているように見えるが、巨大なListを引数として与えるとStack領域が溢れ動作しなくなってしまう *)
let make_list n = List.init n (fun x -> x)
(** 関数の動作確認
  List.init は 引数 n の長さを持つリストを生成する関数である。
  また第二引数には関数を取り、その関数をリストの各要素に適用する。
  ここでは、関数が (fun x -> x) となっているため、単に n を引数にとって n を返すだけである（つまり何もしない）。

  length (make_list 10)
  - : int = 10
*)

(**  巨大な配列を渡した場合
  length (make_list 10_000_000) ;;
  Stack overflow during evaluation (looping recursion?).
*)

(** この理由
  
  関数はstackと呼ばれる領域に格納され、
  格納する際にはどこに関数を格納したかといった関数を呼び出す際に必要な情報も格納する。
  これをstack frameという。

  再帰的な関数呼び出しにおいて、関数を呼び出す度にstackに格納する必要がある。
  呼び出しが完了するとstackから関数は削除（開放）される。

  上記の例では、1000万のstack frameが割り当てる必要が合ったが、利用可能なstack領域が足りないためエラーとなった。
*)

(* 回避方法: 末尾呼び出し最適化 *)
let rec length_plus_n l n =
  match l with 
  | [] -> n
  | _ :: tl -> length_plus_n tl (n + 1)
(** output:
  val length_plus_n : 'a list -> int -> int = <fun>
*)
let length l = length_plus_n l 0
(** output:
  val length : 'a list -> int = <fun>
*)
length [1;2;3;4]
(** output:
  - : int = 4
*)

(* ヘルパ関数 length_plus_n を利用すると、うまくいく *)
length (make_list 10_000_000)
(** output:
  - : int = 10000000
*)


(** この理由

  末尾呼び出し最適化が行われているからである（つまり再帰呼び出しする度に stack frameを割り当てない）。
  呼び出し元が返す値を利用しない場合、その関数は末尾再帰として扱われる。

  このような末尾再帰な関数に対して、末尾呼び出し最適化を行うことで、再帰の度に新しいstack frameを割り当てる必要がなくなり、
  呼び出し元のstack frameを再利用することができるため、stack overflowが発生しなくなった。
*)


(* おまけ *)

(** ポリモーフィック な比較 ※上手くまとまっていない

  ポリモーフィックとは多様性とか多相性とか言ったりする。
  つまり、ポリモーフィックといった場合は任意の型（に対する処理や動作）、と考えていい。

  ある種のプログラミング言語ではポリモーフィックな比較やポリモーフィックな引数の受け入れには寛容であるが、
  OCamlではポリモーフィックな型比較はあまり好まれない。
  これは、型を無視した処理を行ってしまうという性質があるためである。
*)

(* #require "base" *)
open Base.Poly
(** output:

  #require "base";;
  open Base.Poly;;
  "foo" = "bar" ;;
  - : bool = false
  3 = 4 ;;
  - : bool = false
  [1;2;3] = [1;2;3] ;;
  - : bool = true
  (=) ;;
  - : 'a -> 'a -> bool = <fun>
*)

