# GitHub Actionsを使用したECSとECRによるCI/CD

## １．概要

AWSとgithubリポジトリを連携して、AWSにコンテナ環境を構築、更新する

**構成図：**
![image](https://user-images.githubusercontent.com/91934746/181681565-720d6793-4743-42c9-8250-be1262ce2c2d.png)

## ２．AWSとgithubの連携を行う

githubリポジトリを作成して、認定AWSでGithub Actionsを使用してCI/CDを構築する

### ２－１．githubリポジトリを作成する

[githubホーム](https://github.com/)にて「New」を押下して、以下の必須項目に任意値をセットしリポジトリ作成する
- Repository name：リポジトリ名を任意で決める
- Description：作成リポジトリの説明を記載
- 公開設定：Private　※リポジトリ公開はしたくない場合は必須
- Add a README file：プロジェクト説明書になるため、作成しとく良い
- その他項目：デフォルト

### ２－２．セルフホストランナー構築タブを参照

構築したgithubリポジトリの「Settings」タブに移動し、左メニュー一覧の「Actions」配下の「Runner」を押下する

Runner imageにて対象OSの選択を行う　
※本件では、Linuxを使用する

以下がインストール手順になる

**Download**
```
# Create a folder
$ mkdir actions-runner && cd actions-runner

# Download the latest runner package
$ curl -o actions-runner-linux-x64-2.289.3.tar.gz -L -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkJlWUJmeC1mV0x6UWc5ME5LZU9WYTJJT3JMYyJ9.eyJuYW1laWQiOiJkZGRkZGRkZC1kZGRkLWRkZGQtZGRkZC1kZGRkZGRkZGRkZGQiLCJzY3AiOiJBY3Rpb25zUnVudGltZS5QYWNrYWdlRG93bmxvYWQiLCJJZGVudGl0eVR5cGVDbGFpbSI6IlN5c3RlbTpTZXJ2aWNlSWRlbnRpdHkiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiOiJERERERERERC1ERERELUREREQtRERERC1EREREREREREREREQiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ByaW1hcnlzaWQiOiJkZGRkZGRkZC1kZGRkLWRkZGQtZGRkZC1kZGRkZGRkZGRkZGQiLCJhdWkiOiJmMjJlMTNlNS1lM2QwLTRkNDItODk2My1jZmQ3N2IwNThmOWMiLCJzaWQiOiJiNGY3OTM3NS1hOGNhLTQ4YjMtOGYxYS03Njk3NjlmZmU5ZTYiLCJpc3MiOiJnaXRodWIua2RkaS5jb20iLCJhdWQiOiJnaXRodWIua2RkaS5jb20vX3NlcnZpY2VzL3ZzdG9rZW4iLCJuYmYiOjE2NTg0NTUxNjAsImV4cCI6MTY1ODQ1OTM2MH0.VRD5EXGTlBOxLvuKbha09vAMPzX7YzfkYNJIM6_B_yP-FMnSD-mw1-pFGCd3Pfhxo55Xfk7phrN39Nvr70Ru6kJa7OOZ2b2BxqOis2B06cD0fofmSz0FD763AIc90qc-MEFPTRuMPwTxHeTxJk3wS4Q_EccuaGGMxSD_ye8ye7Wr4lThu4eK1IsouIR-gid6JW1On7z-e-rpPqZDO0F-W_4C6iSGG5ODV5lMAl8EICalOzRaLEgv4aisBZtmUBOsQAQh6tDPSaTyHRofWqfc1FRAFPBIqD0zgYoVEB9fIeskYwwGbQ_U1w0VWH0msTJEVzQ5vAG2fXqqLeEczO3S_AKh33odnQTVN0Rdoz4hdAiq5r-jkDu3-4Tz79BU3WAnOFkGI2F6XhPCu9fYJTc5z4q_XCkhUyKud1MUUkPkShCX-3tJa0cFLNTeiq5goindmVwp-nIBZrdS7Tzmw7EpLJNQaMmNTSegEgdzI2Vofo5HJ5-UuRkopFTVqsTe-1_vJpYvBMvLkuU6X1XXox9FSTgSSB9D_BFH5G4q-NcMjESCoZzgfK6sZsSjM9_YZIZzTuf0ZUU3yoVaoYFsoTIU95oZH2MrrT82q0h6afgjokXOyHkEtrV--_SsSZGas8BrnSKBqZkrTvfJi9a8vglqL8Lt9XWDR47VeoKqKHChnGY' https://github.kddi.com/_services/pipelines/_apis/distributedtask/packagedownload/agent/linux-x64/2.289.3

# Optional: Validate the hash
$ echo "bdb4d906f2c49e9cce302172f885f75516943e58e015c1f7997d3a8e286321d3  actions-runner-linux-x64-2.289.3.tar.gz" | shasum -a 256 -c

# Extract the installer
$ tar xzf ./actions-runner-linux-x64-2.289.3.tar.gz
```

ダウンロード完了後、取得したGithubリポジトリの設定を行い、実行する
**Configure**
```
# Create the runner and start the configuration experience
$ ./config.sh --url https://github.com/＜リポジトリ名＞ --token AAAAPENRL3BOXYTKJHY2DXDC3IKN6

# Last step, run it!
$ ./run.sh
```

セルフホストランナーの起動後、作成したワークフローを実行して動作確認を行う
**Using your self-hosted runner**
```
# Use this YAML in your workflow file for each job
runs-on: self-hosted
```

#### 備考：Github又は、Linuxにてプロキシ設定が必要な場合

**※Githubの場合**
以下のコマンドを実行して、設定を行う
- 認証不要の場合
```
$ git config --global http.proxy http://[proxy]:[port]
```

- ユーザー認証が必要な場合
```
$ git config --global http.proxy http[s]://<user_name>:<password>@<proxy_host>:<proxy_port>
$ git config --global https.proxy http[s]://<user_name>:<password>@<proxy_host>:<proxy_port>
```

設定確認は以下のコマンドで実行する
```
$ git config --global -l
http.proxy=http://<user_name>:<password>@<proxy_host>:<proxy_port>
```

不要なプロキシ設定の削除は以下のコマンドを実行する
※プロキシ設定が「https.proxy」の場合
```
git config --global --unset https.proxy
```

**※Linuxで設定する場合**

- 認証不要な場合
```
http_proxy=http[s]://<proxy_host>:<proxy_port>/
https_proxy=http[s]://<proxy_host>:<proxy_port>/
ftp_proxy=http[s]://<proxy_host>:<proxy_port>/
```

- ユーザー認証が必要な場合
```
http_proxy=http[s]://<user_name>:<password>@<proxy_host>:<proxy_port>/
https_proxy=http[s]://<user_name>:<password>@<proxy_host>:<proxy_port>/
ftp_proxy=http[s]://<user_name>:<password>@<proxy_host>:<proxy_port>/
```
|項目|内容|
|:---|:---|
|<proxy_host>|プロキシーサーバーのホスト名、もしくはIPアドレス|
|<proxy_port>|ポート番号|
|<user_name>|ユーザー名、ユーザーID|
|<pass_word>|パスワード |

環境変数にプロキシサーバーの設定ができているかは以下コマンドで確認
```
$ printenv http_proxy
https://aonori:12345678@proxy:8080/ 
$ printenv https_proxy
https://aonori:12345678@proxy:8080/
$ printenv ftp_proxy
https://aonori:12345678@proxy:8080/
```

### ２－３．セルフホストランナーの構築ログ

```
ubuntu@ip-172-31-3-138:~$ mkdir actions-runner && cd actions-runner
ubuntu@ip-172-31-3-138:~/actions-runner$
ubuntu@ip-172-31-3-138:~/actions-runner$
ubuntu@ip-172-31-3-138:~/actions-runner$ curl -o actions-runner-linux-x64-2.294.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.294.0/actions-runner-linux-x64-2.294.0.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  135M  100  135M    0     0  13.6M      0  0:00:09  0:00:09 --:--:--  9.7M
ubuntu@ip-172-31-3-138:~/actions-runner$ echo "a19a09f4eda5716e5d48ba86b6b78fc014880c5619b9dba4a059eaf65e131780  actions-runner-linux-x64-2.294.0.tar.gz" | shasum -a 256 -c
actions-runner-linux-x64-2.294.0.tar.gz: OK
ubuntu@ip-172-31-3-138:~/actions-runner$ tar xzf ./actions-runner-linux-x64-2.294.0.tar.gz
ubuntu@ip-172-31-3-138:~/actions-runner$ ./config.sh --url https://github.com/Tobia-FT/kactus --token AV5NAGUFKJZ3YMV7EQO5WZLC3IXU4

--------------------------------------------------------------------------------
|        ____ _ _   _   _       _          _        _   _                      |
|       / ___(_) |_| | | |_   _| |__      / \   ___| |_(_) ___  _ __  ___      |
|      | |  _| | __| |_| | | | | '_ \    / _ \ / __| __| |/ _ \| '_ \/ __|     |
|      | |_| | | |_|  _  | |_| | |_) |  / ___ \ (__| |_| | (_) | | | \__ \     |
|       \____|_|\__|_| |_|\__,_|_.__/  /_/   \_\___|\__|_|\___/|_| |_|___/     |
|                                                                              |
|                       Self-hosted runner registration                        |
|                                                                              |
--------------------------------------------------------------------------------

# Authentication


√ Connected to GitHub

# Runner Registration

Enter the name of the runner group to add this runner to: [press Enter for Default]

Enter the name of runner: [press Enter for ip-172-31-3-138]

This runner will have the following labels: 'self-hosted', 'Linux', 'X64'
Enter any additional labels (ex. label-1,label-2): [press Enter to skip]

√ Runner successfully added
√ Runner connection is good

# Runner settings

Enter name of work folder: [press Enter for _work]

√ Settings Saved.

ubuntu@ip-172-31-3-138:~/actions-runner$ ./run.sh

√ Connected to GitHub

Current runner version: '2.294.0'
2022-07-22 04:04:22Z: Listening for Jobs


runs-on: ＜実行ワークフロー名＞
```

### ２－４．githubに実行権限（IAMポリシー）を作成

「IAM」→「ポリシー」にて「ポリシー作成」を押下し、付与する権限を追加する
**以下の順で権限を付与**
- サービス
- アクション
- リソース

※リソース条件は、任意で設定する

次のタブでは、任意で「タグ」、「名前」、「説明」を任意値をセットし、ポリシー作成する

備考：不足している権限については、随時追加を行う

### ２－５．IAMロールの作成する

「IAM」→「ロール」→「ロールを作成」にて以下の項目を選択して、作成を行う
- 作成項目：カスタム信頼ポリシー

ロールの信頼関係のポリシーを以下のように設定する
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::＜アカウントID＞:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                    "token.actions.githubusercontent.com:sub": "repo:＜リポジトリ名＞:ref:refs/heads/main"
                }
            }
        }
    ]
}
```
※上項の`:ref:refs/heads/main`でリポジトリの main ブランチのみで実行される

次に前項で作成したポリシーを選択し、「ロール名」、「説明」を任意でセット、作成する

### ２－６．githubにて「アカウントID」、「IAMロール」を設定する

githubコンソール画面の「Settings」タブの「Secrets」配下の「Actions」でシークレットキーを追加する
※本件では、以下の項目で追加する
- AWS_ACCOUNT_ID：アカウントID
- IAM_ROLE：上項で作成したIAMロール


### ２－７．github Actionの動作確認

githubコンソールの「Actions」タブに移動して、「New workflow」を押下する

作成画面にて「Simple workflow」を選択して、以下を作成する
※self-hosted Runnerを設定したEC2のIAMロールに`sts:GetCallerIdentity`を追加が必須

```
name: self-hosted Runner Test

on:
  workflow_dispatch:

permissions:
  id-token: write
  contents: read # actions/checkout のために必要

jobs:
  get-caller-identity:
    runs-on: self-hosted
    steps:
      - name: Checkout the repository
        uses: actions/checkout@v2

      - name: Get Caller Identity
        run: aws sts get-caller-identity
```

作成後、コミットする　
※コミット後、自動的に実行される

## ３．ECRとECSの最小権限ポリシーを作成

最小権限ポリシーを作成し、github Action実行用のIAMロールにアタッチする

### ３－１．IAMポリシーの作成

[IAM > ポリシー]にて「ポリシーを作成」を押下し、JSONタブにて以下の内容で追加
※追加時、権限設定は各ポリシーごと行う
- **ECR用IAMポリシー**
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GetAuthorizationToken",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        },
        {
            "Sid": "PushImageOnly",
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "arn:aws:ecr:ap-northeast-1:<AWSアカウントID>:repository/<リポジトリ名>"
        }
    ]
}
```
- **ECS用IAMポリシー**
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "RegisterTaskDefinition",
            "Effect": "Allow",
            "Action": [
                "ecs:RegisterTaskDefinition"
            ],
            "Resource": "*"
        },
        {
            "Sid": "UpdateService",
            "Effect": "Allow",
            "Action": [
                "ecs:UpdateServicePrimaryTaskSet",
                "ecs:DescribeServices",
                "ecs:UpdateService"
            ],
            "Resource": "arn:aws:ecs:ap-northeast-1:<AWSアカウントID>:service/httpd-cluster/<ECSサービス名>"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::<AWSアカウントID>:role/ecsTaskExecutionRole",
            "Condition": {
                "StringLike": {
                    "iam:PassedToService": "ecs-tasks.amazonaws.com"
                }
            }
        }
    ]
}
```

以下の必須項目に任意値をセットして、「ポリシーを作成」を押下する
- 名前：ポリシー名
- 説明：作成ポリシーについて

作成後、EC2に設定しているIAMロールに上記で作成したポリシーを追加する

## ４．ECRにデプロイするアクションファイルの作成

以下のアクションファイルを作成して、アクションを実行する
```
name: self-hosted Runner Deploy to ECR
on:
  push:
    branches: [main]

jobs:
  deploy:
    name: Deploy to ECR
    runs-on: self-hosted

    steps:
      - name: Check Out
        uses: actions/checkout@v2

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-region: <region: ap-northeast-1>

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1

      - name: Build, tag, and push image to Amazon ECR
        id: build-image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: <リポジトリ名>
        run: |
          # Build a docker container and
          # push it to ECR so that it can
          # be deployed to ECS.
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:${{ github.sha }} .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:${{ github.sha }}
      
```

上記のアクションファイルに`<リポジトリ名>`及び`<region: ap-northeast-1>`を任意値をセットする

## ５．ECSサービス構築

ECRでpushしたリポジトリを起動するのに必要なタスク定義及びクラスター作成を行う

### ５－１．クラスター作成

[コンソールホーム > ECS > クラスター]にて「クラスターの作成」を押下し、クラスターテンプレートの選択する
※今回は、ECRを使用するので「ネットワーキングのみ」を指定する

クラスター設定にて以下の必須項目に任意の値をセットして、「作成」を押下する
- クラスター名
- CloudWatch Container Insights


### ５－２．コンテナイメージのタスク作成

「FARGATE」を指定して、「次のステップ」を押下する

以下の必須入力に任意で値をセットする
- タスク定義名
- タスクロール
- オペレーティングシステムファミリー
- タスク実行ロール
- タスクメモリ (GB)
- タスク CPU (vCPU)
- コンテナの追加
- その他項目はデフォルト

※「コンテナ追加」では、ECRで作成したコンテナイメージを設定する
以下の必須項目に任意の値をセットして追加する
- コンテナ名
- イメージ ：ECRのイメージUURI 
※＜アカウントID＞.dkr.ecr.＜リージョン＞.amazonaws.com/＜リポジトリ＞:＜イメージタグ＞
- その他項目はデフォルト

### ５－３．タスク実行を追加する

「５－１．」で作成したクラスターを[コンソールホーム > ECS > クラスター]から選択する

「タスク」タブにて「新しいタスクの実行」を押下する

以下の入力項目に任意の値をセットして、「タスクの実行」を押下する
- 起動タイプ
- オペレーティングシステムファミリー
- タスク定義
- クラスター VPC
- サブネット
- その他項目はデフォルト

正常に実行で完了
