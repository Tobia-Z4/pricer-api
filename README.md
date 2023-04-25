# Pricer-API

Stock Pricer API 金融市場、株価、為替、Bitcoin 指数　情報 API 取得

# １．概要

yahoo Financial API を使用して、株価や銘柄リストの取得する RESTAPI

機能詳細

使用フレームワーク

-

# ２．環境構築

以下の手順で各モジュールのコンテナ化を行う

## ２－１．格納フォルダに移動

プロジェクトの格納フォルダに移動する

```
cd C:\Work\04.Dev\stock-price-api
```

## ２－２．ビルド実行

```
docker-compose up -d --build
```

# ３．サーバー接続確認

## ３－１．PostgreSQL サーバーの接続情報

以下の内容でデプロイされる

- HostName/Adress：postgres
- Port：5432
- Maintenance database：postgres
- Username：\*\*\*\*
- Password：\*\*\*\*

環境設定は、`./db/db.env`を参照する

各パラメータの説明：

```
POSTGRES_USER: admin
POSTGRES_PASSWORD: password
PGPASSWORD: password123

OSTGRES_USER: admin
POSTGRES_PASSWORD: kawauso0109
POSTGRES_INITDB_ARGS: "--encoding=UTF-8"
POSTGRES_USER: kawauso
POSTGRES_PASSWORD: kawauso0109
PGPASSWORD: kawauso0109
```


## 参考サイト
- [FastAPI - Handling Errors](https://fastapi.tiangolo.com/ja/tutorial/handling-errors/)
