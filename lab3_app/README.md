# Мобилни Информациски Системи - Лабораториска вежба 3

## Видео
Демонстративното видео е достапно [тука](https://finkiukim-my.sharepoint.com/:v:/g/personal/hristijan_pusoski_students_finki_ukim_mk/IQDesV5mw7UUTJLxQAKYforJAS81oalRvNB7UB_DtbOTAwQ?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=RfNIRA).

## Белешки

Апликацијата ги користи следните Firebase сервиси:
- Firebase Authentication за анонимно најавување/регистрација,
- Firestore за зачувување на омилените рецепти на корисниците,
- Firebase Cloud Messaging за испраќање известување.

> [!NOTE]  
> Овој репозиториум е поврзан со GitHub Actions делот на репозиториумот [mobis-25-actions](https://github.com/pusoski/mobis-25-actions), во којшто се прави trigger за Firebase Cloud Messaging. Во mobis-25-actions постои и CRON фајл којшто го извршува trigger-от за испраќање известување секојдневно.

> [!IMPORTANT]  
> По инсталација на .apk фајлот (достапен [тука](https://github.com/pusoski/mobis-25/releases/tag/lab3)), потребно е рачно овозможување на известувања за апликацијата, во Settings на уредот.