# Introduction

本節では OCaml を利用するために必要な手順及びツールのインストール方法を解説する。

## OCaml の紹介

ここでは OCaml の魅力を語りたい・・・

## OCaml のインストール方法

お手元でOcamlを始めるために必要なプログラムをインストールする。

開発環境には Linux を想定しているが、
他の環境をどうしても使いたい場合は頑張ってもらいたい。

### OPAMのインストール

OCaml を始めるのであれば、
OCamlのパッケージ管理システムである `OPAM` を利用すると良いだろう。

最新の `OAPM` をインストールするには 以下のコマンドを実行する。

なお、先頭の `$` はコマンドラインのプロンプトを表している。

```
$sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
$ which opam
$ /home/toshiki/bin/opam

$ opam --version
2.05
```

2019/11/09時点で最新のものがダウンロードされていることを確認されたい。

詳細なインストール方法については下記を参照する。

* https://opam.ocaml.org/doc/Install.html

### OCamlのインストール

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
# switchcompilerdescription
→/home/toshiki/work/Ocaml/effective-ocamlocaml-base-compiler.4.08.1/home/toshiki/work/Ocaml/effective-ocaml
```

プロジェクトはディレクトリ単位で分けることができる。

また、プロジェクトで利用するOCamlのバージョンを指定する。  
今回は、先程インストールした4.08.1を利用することにしよう。

一旦別プロジェクトに移動してしまった場合でも、下記のようなコマンドを実行することで、
また自分の作成したプロジェクトに戻ってくることができる。

先頭の `#` はコメントを表している。

```
$ opam switch 4.08.1
# ここで 4.08.1 に移動したとする
$ eval $(opam env)
$ opam --version
4.08.1

# その後、自分のプロジェクトに戻る場合は以下のコマンドを実行する
$ eval $(opam env --switch=/home/toshiki/work/Ocaml/effective-ocaml --set-switch)
$ opam switch
# switchcompilerdescription
→/home/toshiki/work/Ocaml/effective-ocamlocaml-base-compiler.4.08.1/home/toshiki/work/Ocaml/effective-ocaml
```

`OPAM` にて 複数の Version 切り替えについては、下記を参照する。

* https://discuss.ocaml.org/t/opam-command-for-a-local-switch-how-to-use-it/2642
*)


## 便利なツール

OCamlをコマンドラインやEmacsで利用するために必要な
パッケージ群のインストールを行う。

以下のコマンドを実行し、ツールをインストールする。  
（これは、ほしい読者のみ対応すれば良い）

```
$ opam install utop merlin ocp-indent dune tuareg
```

以下に、導入したツールの簡単な説明を示す。

* `utop`: コマンドラインでリッチなUIを提供するツール
* `merlin`: Emacs でOCamlを書く際にモジュールや関数の定義を補完してくれるツール
* `ocp-indent`: Emacs でOCamlを書く際にインデントを良さげにしてくれるツール
* `dune`: OCaml のビルドツール
* `tuareg`: Emacs でOCamlを書く際に利用するOCamlモード

## 簡単なサンプルの実行

本ディレクトリに `sum.ml` という、
入力された数の合計を表示するプログラムを配置した。

下記コマンドを実行し、`sum.ml` に必要なパッケージを導入かつビルドし、
実際の挙動を試されたい。

```
$ opam install base
# 下記コマンドを実行しビルドを行う
$ dune build sum.exe
# プログラムを実行し、sum.exe の挙動を確かめる
$ ./_build/default/sum.exe
  1
  2
  3
  <Ctrl-d>
  total: 6.000000
```

