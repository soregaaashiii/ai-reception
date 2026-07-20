# AI受付 初期設計

## 独立性

本アプリケーションはAICOOとコード、DB、認証、環境変数、Git、Renderサービスを共有しない独立SaaSとする。

## テナント境界

- `Organization` を契約企業の境界とする。
- `User` と `Location` は必ず `Organization` に所属する。
- 今後追加する主要業務モデルには `organization_id` を必須で持たせる。
- コントローラは常に `current_organization` から関連をたどり、IDだけの全体検索を禁止する。
- 拠点単位で扱うデータは `location_id` を任意または必須で持ち、契約企業との整合性を検証する。
- 運営者管理は契約企業の利用者認証と分離し、後続工程で専用namespaceを設ける。

## モデル案

基盤: Organization、Location、User。

業務: StaffProfile、Customer、Inquiry、Conversation、Message、Call、Recording、Transcript、Summary、KnowledgeItem、SimilarQuestion、ImprovementGroup、AnswerDraft、KnowledgeApproval、KnowledgeRevision、Appointment、NotificationSetting、NotificationDelivery、Conversion、DailyMetric。

会話・発言・通話・録音・文字起こし・通知成否・回答根拠は検索と分析の要件があるため、JSONへ集約せず正規化を基本とする。外部サービスの生レスポンスなど補助情報だけJSONを許容する。

## 画面構成

主要ナビゲーションはホーム、問い合わせ、AIの知識、予約、分析、設定の6項目。ログイン、初期登録、7段階の初期設定、問い合わせ詳細、改善候補、登録済み知識、担当者・通知・電話・契約設定、運営者管理は各主要画面の配下に置く。

## 実装順序

1. テナント境界と認証の統合テスト
2. 初期登録・ステップ式初期設定
3. 担当者・顧客・問い合わせの正規化モデル
4. ホーム、問い合わせ一覧・詳細
5. 会話、発言、通話、録音、文字起こし
6. AI知識、改善候補、承認・統合・分割
7. 予約
8. 通知設定と履歴
9. KPI・成約分析
10. 運営者管理、契約・請求
11. 外部電話、AI、通知、CRM連携

## UI・UX方針

日本語のみ、白基調、主操作を1つに絞り、状態は文字と色で表示する。一覧と詳細を分離し、パンくずと戻り導線を用意する。ホームは「今やること」を先に示す。スマートフォンでは主要メニューを折り返し、空状態とエラーには次の操作を明記する。
