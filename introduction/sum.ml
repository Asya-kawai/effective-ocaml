(* opam install base stdio *)

(** In utop, `#require "base"` and `#require "stdio"` *)
open Base
open Stdio

let rec read_and_accum accum = 
  let line = In_channel.input_line In_channel.stdin in
  match line with
  | None -> accum
  | Some x -> read_and_accum (accum +. Float.of_string x)

(* main function *)
let () =
  printf "total: %f\n" (read_and_accum 0.)


(**
  作り終わったら dune でビルドしてみる。
  
  duneコマンドには設定ファイルduneが必要で、リポジトリ内にすでに用意してある。
  （コマンド名と同じ名前の設定ファイルなのでややこしい）

  下記コマンドを実行することで、_build/default/sum.exe というネイティブコードを作成できる。

  ```
    $ dune build sum.exe
  ```

  下記コマンドで実行し、Crtl-Dを入力するとこで入力した合計値を出力する。

  ```
    $ ./_build/default/sum.exe
      1
      2
      3
      total: 6.000000 
  ```
*)
