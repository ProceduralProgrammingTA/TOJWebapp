# 実習課題 ex1-2[A課題]
***
実行時間制限 : 1 sec

**（数式がうまく表示されない場合は、ページを更新すると解決する可能性があります。）**

***

## 問題文
以下の連立方程式を解く C プログラムを作成してください。

$$
\begin{eqnarray}
  \left\\{
    \begin{array}{l}
      ax + by = p \\\\
      cx + dy = q
    \end{array}
  \right.
\end{eqnarray}
$$

* **この問題に限り、1 文字変数 $a, b, c, d, p, q, x, y$ の使用が認められます。**



## 入力

```sh
a b c d p q
```

* 一行目に問題文中の連立方程式の係数を表す実数 $a, b, c, d, p, q$ がこの順に半角スペース区切りで入力されます。
* 入力の末尾に改行が 1 つ入ります。

## 制約
全てのテストケースは以下の制約を満たします。

* $-200.0 \le a, b, c, d, p, q \le 200.0$
* 係数行列 $\begin{pmatrix} a & b \\\\ c & d \end{pmatrix}$ は正則である（必ず唯一の解がある）


## 出力

```sh
x y
```

* 問題文中の連立方程式の解を表す実数 $x, y$ をこの順に半角スペース区切りで出力してください。
* $x, y$ は小数第 4 位を四捨五入してちょうど小数第 3 位まで出力するようにしてください。
  * [Hint] 上に書かれたことを実現する方法のひとつに、フォーマット指定子による表示桁数の指定があります。
* 末尾に改行を入れ、余計な文字、空行を含んではいけません。

## 入出力例

入力例 1:

```sh
1.0 2.0 0 -3.0 3.0 1.5
```

出力例 1:

```sh
4.000 -0.500
```


## 注意

* **最後に改行を入れることを忘れない**
* **必ず手元で動作確認をしてから提出すること**

