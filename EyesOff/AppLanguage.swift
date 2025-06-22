import Foundation

let WEBSITE_URL = "https://eyesoff.vercel.app"
let VERSION_INFO = "1.0.0"

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
        language: "Language"
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
        language: "Ngôn ngữ"
    )

    static let ja = LocalizedStrings(
        breakTitle: "👁️ 目を休める時間です！",
        breakBody: "🧘 目を休めましょう！\n\n⏳ 20秒間、6メートル先を見てください。\n💡 ゆっくりまばたきして、深呼吸しましょう。",
        breakButton: "了解！",

        backToWorkTitle: "👁️ EyesOff",
        backToWorkBody: "作業に戻っても大丈夫です！",

        aboutTitle: "EyesOff (20-20-20)",
        aboutBody: """
        バージョン \(VERSION_INFO)

        👁️ EyesOffは20-20-20ルールを守るためのリマインダーです：
        20分ごとに、6メートル先を20秒間見ましょう。

        🔗 Website: \(WEBSITE_URL)
        👨‍💻 開発者: Lavisar
        """,
        launchAtLogin: "ログイン時に起動",
        notificationSettings: "通知設定",
        aboutMenu: "EyesOffについて",
        reportBug: "バグを報告する",
        quit: "終了",
        selectSound: "サウンドを選択",
        language: "言語"
    )

    static let ko = LocalizedStrings(
        breakTitle: "👁️ 눈 휴식 시간입니다!",
        breakBody: "🧘 눈을 잠시 쉬게 해주세요!\n\n⏳ 20초 동안 6미터 떨어진 곳을 바라보세요.\n💡 천천히 눈을 깜빡이고 깊게 숨을 쉬세요.",
        breakButton: "알겠어요!",

        backToWorkTitle: "👁️ EyesOff",
        backToWorkBody: "이제 다시 작업을 시작해도 됩니다!",

        aboutTitle: "EyesOff (20-20-20)",
        aboutBody: """
        버전 \(VERSION_INFO)

        👁️ EyesOff는 20-20-20 규칙을 따르도록 도와줍니다:
        20분마다 6미터 떨어진 곳을 20초 동안 바라보세요.

        🔗 Website: \(WEBSITE_URL)
        👨‍💻 개발자: Lavisar
        """,
        launchAtLogin: "로그인 시 실행",
        notificationSettings: "알림 설정",
        aboutMenu: "EyesOff 정보",
        reportBug: "버그 신고",
        quit: "종료",
        selectSound: "소리 선택",
        language: "언어"
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
        language: "Idioma"
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
        language: "语言"
    )
}
