import Foundation

let WEBSITE_URL = "https://eyesoff.vercel.app"
let VERSION_INFO = "1.0.1"

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case vietnamese = "Tiếng Việt"
    case japanese = "日本語"
    case korean = "한국어"
    case spanish = "Español"
    case chineseSimplified = "简体中文"

    static var current: AppLanguage {
        if let saved = UserDefaults.standard.string(forKey: "AppLanguage"),
           let lang = AppLanguage(rawValue: saved) {
            return lang
        }
        let preferredLang = Locale.preferredLanguages.first ?? "en"
        print("lang detected: ", preferredLang)

        if preferredLang.hasPrefix("vi") {
            return .vietnamese
        } else if preferredLang.hasPrefix("ja") {
            return .japanese
        } else if preferredLang.hasPrefix("ko") {
            return .korean
        } else if preferredLang.hasPrefix("es") {
            return .spanish
        } else if preferredLang.hasPrefix("zh") {
            return .chineseSimplified
        } else {
            return .english
        }
    }

    var localizedStrings: LocalizedStrings {
        switch self {
        case .english: return .en
        case .vietnamese: return .vi
        case .japanese: return .ja
        case .korean: return .ko
        case .spanish: return .es
        case .chineseSimplified: return .zhHans
        }
    }
}

struct LocalizedStrings {
    let breakTitle: String
    let breakBody: String
    let breakButton: String
    let backToWorkTitle: String
    let backToWorkBody: String
    let aboutTitle: String
    let aboutBody: String
    let launchAtLogin: String
    let notificationSettings: String
    let aboutMenu: String
    let reportBug: String
    let quit: String
    let selectSound: String
    let language: String
    let ignoreList: String
    let selectIcon: String
    let checkForUpdate: String
    let updateAvailableTitle: String
    let updateAvailableBody: String
    let noUpdateTitle: String
    let noUpdateBody: String
    let updateCheckFailedTitle: String
    let updateCheckFailedBody: String
    let okButton: String
    let downloadButton: String

    static let en = LocalizedStrings(
        breakTitle: "👁️ EyesOff Break Time!",
        breakBody: "🧘 Time to rest your eyes!\n\n⏳ Look 20 feet away for 20 seconds.\n💡 Blink slowly. Breathe deeply.",
        breakButton: "Got it!",

        backToWorkTitle: "👁️ EyeOff",
        backToWorkBody: "You can now return to work now",

        aboutTitle: "EyesOff (20-20-20)",
        aboutBody: """
        Version \(VERSION_INFO)

        👁️ EyesOff reminds you to follow the 20-20-20 rule:
        Every 20 minutes, look at something 20 feet away for 20 seconds.

        🔗 Website: \(WEBSITE_URL)
        👨‍💻 Developed by Lavisar
        """,
        launchAtLogin: "Launch at Login",
        notificationSettings: "Notification Settings",
        aboutMenu: "About EyesOff",
        reportBug: "Report a Bug",
        quit: "Quit",
        selectSound: "Select Sound",
        language: "Language",
        ignoreList: "Manage Ignored Apps",
        selectIcon: "Select Icon",
        checkForUpdate: "Check for Updates",
        updateAvailableTitle: "Update Available!",
        updateAvailableBody: "A new version (%@) is available. You are currently using version %@.",
        noUpdateTitle: "No Updates",
        noUpdateBody: "You are using the latest version of EyesOff.",
        updateCheckFailedTitle: "Update Check Failed",
        updateCheckFailedBody: "Could not check for updates. Please try again later.",
        okButton: "OK",
        downloadButton: "Download"
    )

    static let vi = LocalizedStrings(
        breakTitle: "👁️ Đến giờ nghỉ mắt!",
        breakBody: "🧘 Nghỉ ngơi cho mắt nào!\n\n⏳ Nhìn xa 6 mét trong 20 giây.\n💡 Chớp mắt chậm, hít thở sâu.",
        breakButton: "Đã hiểu!",

        backToWorkTitle: "👁️ EyesOff",
        backToWorkBody: "Bạn có thể bắt đầu làm việc lại rồi.",

        aboutTitle: "EyesOff (20-20-20)",
        aboutBody: """
        Phiên bản \(VERSION_INFO)

        👁️ EyesOff nhắc bạn áp dụng quy tắc 20-20-20:
        Mỗi 20 phút, hãy nhìn vật cách xa 6 mét trong 20 giây.

        🔗 Website: \(WEBSITE_URL)
        👨‍💻 Phát triển bởi Lavisar
        """,
        launchAtLogin: "Khởi động cùng hệ thống",
        notificationSettings: "Cài đặt thông báo",
        aboutMenu: "Giới thiệu EyesOff",
        reportBug: "Báo lỗi",
        quit: "Thoát",
        selectSound: "Chọn âm thanh",
        language: "Ngôn ngữ",
        ignoreList: "Quản lý ứng dụng bỏ qua",
        selectIcon: "Chọn biểu tượng",
        checkForUpdate: "Kiểm tra cập nhật",
        updateAvailableTitle: "Có bản cập nhật mới!",
        updateAvailableBody: "Phiên bản mới (%@) đã có. Bạn đang dùng phiên bản %@.",
        noUpdateTitle: "Không có cập nhật",
        noUpdateBody: "Bạn đang dùng phiên bản mới nhất của EyesOff.",
        updateCheckFailedTitle: "Không thể kiểm tra cập nhật",
        updateCheckFailedBody: "Không thể kiểm tra cập nhật. Vui lòng thử lại sau.",
        okButton: "OK",
        downloadButton: "Tải xuống"
    )

    static let ja = LocalizedStrings(
        breakTitle: "👁️ 休憩の時間です！",
        breakBody: "🧘 目を休ませましょう！\n\n⏳ 20秒間、6メートル先を見つめてください。\n💡 ゆっくりまばたきをして、深呼吸しましょう。",
        breakButton: "了解！",

        backToWorkTitle: "👁️ EyesOff",
        backToWorkBody: "作業を再開できます。",

        aboutTitle: "EyesOff (20-20-20)",
        aboutBody: """
        バージョン \(VERSION_INFO)

        👁️ EyesOffは20-20-20ルールをサポートするリマインダーです。
        20分ごとに、6メートル先を20秒間見つめましょう。

        🔗 ウェブサイト: \(WEBSITE_URL)
        👨‍💻 開発者: Lavisar
        """,

        launchAtLogin: "ログイン時に起動",
        notificationSettings: "通知設定",
        aboutMenu: "EyesOffについて",
        reportBug: "バグを報告する",
        quit: "終了",
        selectSound: "サウンドを選択",
        language: "言語",
        ignoreList: "無視するアプリを管理",
        selectIcon: "アイコンを選択",

        checkForUpdate: "アップデートを確認",
        updateAvailableTitle: "新しいアップデートがあります！",
        updateAvailableBody: "バージョン %@ が利用可能です。現在のバージョンは %@ です。",
        noUpdateTitle: "最新版です",
        noUpdateBody: "EyesOffは最新バージョンを使用しています。",
        updateCheckFailedTitle: "アップデートの確認に失敗しました",
        updateCheckFailedBody: "アップデートを確認できませんでした。後でもう一度お試しください。",
        okButton: "OK",
        downloadButton: "ダウンロード"
    )

    static let ko = LocalizedStrings(
        breakTitle: "👁️ 눈을 쉴 시간이에요!",
        breakBody: "🧘 눈을 잠시 쉬게 해주세요!\n\n⏳ 20초 동안 6미터 앞을 바라보세요.\n💡 천천히 눈을 깜빡이고 깊게 숨을 쉬세요.",
        breakButton: "확인!",

        backToWorkTitle: "👁️ EyesOff",
        backToWorkBody: "이제 다시 작업을 시작할 수 있어요!",

        aboutTitle: "EyesOff (20-20-20)",
        aboutBody: """
        버전 \(VERSION_INFO)

        👁️ EyesOff는 20-20-20 규칙을 실천하도록 도와주는 리마인더입니다.
        20분마다 6미터 떨어진 곳을 20초간 바라보세요.

        🔗 웹사이트: \(WEBSITE_URL)
        👨‍💻 개발자: Lavisar
        """,

        launchAtLogin: "로그인 시 자동 실행",
        notificationSettings: "알림 설정",
        aboutMenu: "EyesOff 정보",
        reportBug: "버그 신고",
        quit: "종료",
        selectSound: "소리 선택",
        language: "언어",
        ignoreList: "무시할 앱 관리",
        selectIcon: "아이콘 선택",

        checkForUpdate: "업데이트 확인",
        updateAvailableTitle: "새로운 업데이트가 있어요!",
        updateAvailableBody: "버전 %@가 출시되었습니다. 현재 사용 중인 버전은 %@입니다.",
        noUpdateTitle: "최신 버전입니다",
        noUpdateBody: "EyesOff는 최신 버전을 사용 중입니다.",
        updateCheckFailedTitle: "업데이트 확인 실패",
        updateCheckFailedBody: "업데이트를 확인할 수 없습니다. 나중에 다시 시도해 주세요.",
        okButton: "확인",
        downloadButton: "다운로드"
    )

    static let es = LocalizedStrings(
        breakTitle: "👁️ ¡Hora de descansar la vista!",
        breakBody: "🧘 ¡Es momento de descansar los ojos!\n\n⏳ Mira a 6 metros de distancia durante 20 segundos.\n💡 Parpadea lentamente y respira profundo.",
        breakButton: "¡Entendido!",

        backToWorkTitle: "👁️ EyesOff",
        backToWorkBody: "¡Ahora puedes volver al trabajo!",

        aboutTitle: "EyesOff (20-20-20)",
        aboutBody: """
        Versión \(VERSION_INFO)

        👁️ EyesOff te recuerda seguir la regla 20-20-20:
        Cada 20 minutos, mira algo a 6 metros de distancia por 20 segundos.

        🔗 Website: \(WEBSITE_URL)
        👨‍💻 Desarrollado por Lavisar
        """,
        launchAtLogin: "Iniciar al encender",
        notificationSettings: "Configuración de notificaciones",
        aboutMenu: "Acerca de EyesOff",
        reportBug: "Informar un error",
        quit: "Salir",
        selectSound: "Seleccionar sonido",
        language: "Idioma",
        ignoreList: "Gestionar aplicaciones ignoradas",
        selectIcon: "Seleccionar icono",
        checkForUpdate: "Buscar actualizaciones",
        updateAvailableTitle: "¡Actualización disponible!",
        updateAvailableBody: "Hay una nueva versión (%@) disponible. Actualmente estás usando la versión %@.",
        noUpdateTitle: "No hay actualizaciones",
        noUpdateBody: "Estás usando la última versión de EyesOff.",
        updateCheckFailedTitle: "Fallo al buscar actualizaciones",
        updateCheckFailedBody: "No se pudieron buscar actualizaciones. Por favor, inténtalo de nuevo más tarde.",
        okButton: "OK",
        downloadButton: "Descargar"
    )

    static let zhHans = LocalizedStrings(
        breakTitle: "👁️ 是时候休息眼睛啦！",
        breakBody: "🧘 放松一下眼睛吧！\n\n⏳ 向6米远处看20秒。\n💡 慢慢眨眼，深呼吸。",
        breakButton: "知道了！",

        backToWorkTitle: "👁️ EyesOff",
        backToWorkBody: "你现在可以开始工作了！",

        aboutTitle: "EyesOff (20-20-20)",
        aboutBody: """
        版本 \(VERSION_INFO)

        👁️ EyesOff 提醒你遵循 20-20-20 规则：
        每20分钟，看向6米远的地方，持续20秒。

        🔗 Website: \(WEBSITE_URL)
        👨‍💻 开发者：Lavisar
        """,
        launchAtLogin: "开机时启动",
        notificationSettings: "通知设置",
        aboutMenu: "关于 EyesOff",
        reportBug: "报告错误",
        quit: "退出",
        selectSound: "选择声音",
        language: "语言",
        ignoreList: "管理忽略的应用程序",
        selectIcon: "选择图标",
        checkForUpdate: "检查更新",
        updateAvailableTitle: "有可用更新！",
        updateAvailableBody: "新版本 (%@) 可用。您当前使用的是版本 %@。",
        noUpdateTitle: "无更新",
        noUpdateBody: "您正在使用最新版本的 EyesOff。",
        updateCheckFailedTitle: "检查更新失败",
        updateCheckFailedBody: "无法检查更新。请稍后再试。",
        okButton: "确定",
        downloadButton: "下载"
    )
}
