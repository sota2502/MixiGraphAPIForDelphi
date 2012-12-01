# 実行手順
## コードの書き換え
コード内のCONSUMER_KEY,　CONSUMER_SECRET,　REDIRECT_URIを適切に書き換えてください。
## Authorization codeの入手
以下のURLにWebブラウザにてアクセスし、リダイレクト先に含まれるcodeパラメータ値を入手する。

    https://mixi.jp/connect_authorize.pl?client_id=[YOUR CONSUMER KEY]&scope=r_profile

## 実行
Delphiでコンパイル後、コンソールから実行します。
    $ MixiGraphAPI.exe


## 仕様ライブラリ
Indy http://www.indyproject.org/
Indy OpenSSL 0.9.8h IntraWeb Edition http://indy.fulgan.com/SSL/
superobject http://code.google.com/p/superobject/
