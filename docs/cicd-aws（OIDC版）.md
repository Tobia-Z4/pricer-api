# GitHub Actionsを使用したECSとECRによるCI/CD

## １．概要

AWSとgithubリポジトリを連携して、AWSにコンテナ環境を構築、更新する

**構成図：**
![image](https://user-images.githubusercontent.com/91934746/181681565-720d6793-4743-42c9-8250-be1262ce2c2d.png)

## ２．AWSとgithubの連携を行う

githubリポジトリを作成して、OpenID Connect設定して連携を行う

### ２－１．githubリポジトリを作成する

[githubホーム](https://github.com/)にて「New」を押下して、以下の必須項目に任意値をセットしリポジトリ作成する
- Repository name：リポジトリ名を任意で決める
- Description：作成リポジトリの説明を記載
- 公開設定：Private　※リポジトリ公開はしたくない場合は必須
- Add a README file：プロジェクト説明書になるため、作成しとく良い
- その他項目：デフォルト

### ２－２．ID プロバイダの設定

[AWSコンソール](https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1)から「IAM」→「ID プロバイダ」にて、以下の設定でプロバイダを追加する
- プロバイダのタイプ：OpenID Connect
- プロバイダの URL： https://token.actions.githubusercontent.com
- 対象者: sts.amazonaws.com

GitHub が提供する OIDC プロバイダの情報を AWS に登録は完了

### ２－３．githubに実行権限（IAMポリシー）を作成

「IAM」→「ポリシー」にて「ポリシー作成」を押下し、付与する権限を追加する
**以下の順で権限を付与**
- サービス
- アクション
- リソース

※リソース条件は、任意で設定する

次のタブでは、任意で「タグ」、「名前」、「説明」を任意値をセットし、ポリシー作成する

備考：不足している権限については、随時追加を行う

### ２－４．IAMロールの作成する

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

### ２－５．githubにて「アカウントID」、「IAMロール」を設定する

githubコンソール画面の「Settings」タブの「Secrets」配下の「Actions」でシークレットキーを追加する
※本件では、以下の項目で追加する
- AWS_ACCOUNT_ID：アカウントID
- IAM_ROLE：上項で作成したIAMロール


### ２－６．github Actionの動作確認

githubコンソールの「Actions」タブに移動して、「New workflow」を押下する

作成画面にて「Simple workflow」を選択して、以下を作成する
```
name: OIDC Test

on:
  workflow_dispatch:

permissions:
  id-token: write
  contents: read # actions/checkout のために必要

jobs:
  get-caller-identity:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: aws-actions/configure-aws-credentials@v1
        with:
          role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT_ID }}:role/${{ secrets.IAM_ROLE}}
          aws-region: ap-northeast-1
      - run: aws sts get-caller-identity
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


## ４．ECSサービス構築

ECRでpushしたリポジトリを起動するのに必要なタスク定義及びクラスター作成を行う

### ４－１．クラスター作成

[コンソールホーム > ECS > クラスター]にて「クラスターの作成」を押下し、クラスターテンプレートの選択する
※今回は、ECRを使用するので「ネットワーキングのみ」を指定する

クラスター設定にて以下の必須項目に任意の値をセットして、「作成」を押下する
- クラスター名
- CloudWatch Container Insights


### ４－２．コンテナイメージのタスク作成

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

### ４－３．タスク実行を追加する

「４－１．」で作成したクラスターを[コンソールホーム > ECS > クラスター]から選択する

「タスク」タブにて「新しいタスクの実行」を押下する

以下の入力項目に任意の値をセットして、「タスクの実行」を押下する
- 起動タイプ
- オペレーティングシステムファミリー
- タスク定義
- クラスター VPC
- サブネット
- その他項目はデフォルト

正常に実行で完了