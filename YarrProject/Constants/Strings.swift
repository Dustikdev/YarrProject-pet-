import Foundation

struct Strings {
    
    static let modelName = "DataModel"

    struct Alerts {
        static let alertTitleProjectList = "Добавьте новый проект"
        static let alertMessage = "Укажите имя"
        static let alertAddActionTitle = "Добавить"
        static let alertEditActionTitle = "Переименовать"
        static let alertCancelActionTitle = "Отмена"
        static let alertTextFieldPlaceholder = "Напишите что-нибудь..."
        static let alertTitleProjectDetails = "Добавить новое фото из галереи"
        static let alertTitleEdit = "Введите новое описание"
    }

    struct NavigationBarTitles {
        static let projectListNavigationbarTitle = "Проекты"
        static let projectDetailsNavigationbarTitle = "Конкретный проект"
    }
    
    struct Entities {
        static let projectsListEntity = "ProjectsListData"
        static let projectDetailsEntity = "ProjectDetailsData"
    }
    
    struct ContextMenuTitles {
        static let edit = "Изменить фото"
        static let delete = "Удалить проект"
        static let menuName = "Параметры"
        static let rename = "Переименовать"
    }
}
