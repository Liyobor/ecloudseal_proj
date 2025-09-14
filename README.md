# ecloudseal_proj

雲璽科技面試題目。

## 主旨

設計一個具備雙因子驗證（Multi-Factor Authentication, MFA）的登入機制：

1. 第一因子為使用者帳號密碼
2. 第二因子為生物辨識（指紋 Fingerprint 或臉部 Face Recognition）

此系統模擬企業內部應用登入需求，要求兼顧安全性與使用者體驗。

## 開發要求

1. 登入頁面輸入「帳號」與「密碼」
2. 使用 EncryptedSharedPreferences / Keystore 儲存並讀取帳號密碼資訊
3. 若帳密正確，跳出 Face ID 驗證
4. 驗證成功後進入主畫面，顯示歡迎訊息與使用者帳號
5. 錯誤輸入三次帳號密碼後顯示鎖定提示
6. 生物辨識驗證失敗時應有錯誤提示並返回登入畫面


## 運作方式

由 main.dart 入口進入 SplashPage -> SplashPage 會將頁面導向登入頁面(LoginPage) 

LoginPage 包含 帳號輸入框,密碼輸入框,登入介紹,登入按鈕,忘記密碼(功能未實作)按鈕,顯示已輸入的密碼按鈕,登入失敗過多次的提示框(僅顯示登入失敗次數過多,無限制登入的功能)

此App並無註冊按鈕,新帳號第一次登入的時會將帳號密碼寫入 EncryptedSharedPreferences 做紀錄(其實此操作類似註冊),後續使用此帳號登入時須使用第一次輸入的密碼進行登入

帳號密碼輸入正確之後,會跳出原生生物辨識驗證的介面,驗證成功後會跳轉到HomePage,Android的生物辨識介面是覆蓋在原畫面上,辨識不符合則會提示用戶重試,錯誤次數過多會將畫面鎖定,按cancel則會返回主畫面

而 iOS 和 Android 的原生 API (BiometricPrompt 或 LocalAuthentication）設計上禁止將這些敏感資訊暴露給應用程式,所以無法保存這些資料

當帳號,密碼和生物辨識都通過則會導向HomePage

HomePage則只有用戶的登入帳號以及歡迎訊息
