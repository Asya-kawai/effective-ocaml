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
