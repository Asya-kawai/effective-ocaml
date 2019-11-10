(**
  ## OCaml の紹介。

  OCaml について語る。

  ## OCaml のインストール方法

  お手元でOcamlを始めるために必要なプログラムをインストールする。
  開発環境には Linux を想定しているが、
  他の環境をどうしても使いたい場合は頑張ってもらいたい。

  ### OPAMのインストール
  OCaml を始めるのであれば、OCamlのパッケージ管理システムであるOPAMを利用すると良いだろう。

  ```
    $  sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
    $ which opam
    $ /home/toshiki/bin/opam

    $ opam --version
      2.05
  ```

  2019/11/09時点で最新のものがダウンロードされていることを確認する。

  #### 参考

  * https://opam.ocaml.org/doc/Install.html

  ### OCaml の最新版をインストールする

  以下のコマンドを実行し、その時点で最新のバージョンを利用する。
  最新のバージョンは以下から確認できる。
  * https://ocaml.org/docs/install.html
  
  ```
   $ opam switch create 4.08.1
   $ eval $(opam env)
   $ ocaml --version
     The OCaml toplevel, version 4.08.1
  ```

  ## 自分の作業用プロジェクトを作る

  プロジェクト毎に利用したいパッケージを分けたい場合もある。

  その時は、下記コマンドを実行し、個別のプロジェクトを作成する。  
  この利点は、必要なパッケージのみをそのプロジェクトで利用するようにし、
  不要なパッケージを入れ込まないことにある。

  ```
    $ mkdir effective-ocaml
    $ opam switch create . ocaml-base-compiler.4.08.1
    $ eval $(opam env)
    $ opam switch
      #   switch                                    compiler                    description
      →  /home/toshiki/work/Ocaml/effective-ocaml  ocaml-base-compiler.4.08.1  /home/toshiki/work/Ocaml/effective-ocaml
  ```

  プロジェクトはディレクトリ単位で分けることができる。

  また、プロジェクトで利用するOCamlのバージョンを指定する。  
  今回は、先程インストールした4.08.1を利用することにしよう。

  一旦別プロジェクトに移動してしまった場合でも、下記のようなコマンドを実行することで、
  また自分の作成したプロジェクトに戻ってくることができる。

  ```
    $ opam switch 4.08.1    
    # ここで 4.08.1 に移動したとする
    $ eval $(opam env)
    $ opam --version
      4.08.1

    # その後、自分のプロジェクトに戻る場合は以下のコマンドを実行する
    $ eval $(opam env --switch=/home/toshiki/work/Ocaml/effective-ocaml --set-switch)
    $ opam switch
      #   switch                                    compiler                    description
      →  /home/toshiki/work/Ocaml/effective-ocaml  ocaml-base-compiler.4.08.1  /home/toshiki/work/Ocaml/effective-ocaml
  ```

  #### 参考

  * https://discuss.ocaml.org/t/opam-command-for-a-local-switch-how-to-use-it/2642
*)

(**
   OCaml をコマンドラインやEmacsで利用するために必要なパッケージ群のインストール

   ほしい人だけ対応すれば良い。

   ```
     $ opam install utop merlin ocp-indent dune tuareg
   ```

   * utop: コマンドラインでリッチなUIを提供するツール
   * merlin: Emacs でOCamlを書く際にモジュールや関数の定義を補完してくれるツール
   * ocp-indent: Emacs でOCamlを書く際にインデントを良さげにしてくれるツール
   * tuareg: Emacs でOCamlを書く際に利用するOCamlモード
*)


(* OCaml を計算機として利用してみる *)

(** Baseは標準パッケージ
   ただし、最初からは入っていないので、自分でインストールする必要がある。

  ```
    $ opam install base
  ```
*)

(* 実践 *)
let a = 1 + 4
let b = 8 / 3
let c = 3.5 +. 6.
let d = 3 * 5 > 14
