namespace java com.rbkmoney.bouncer.decisions
namespace erlang bdcs

enum ContextFragmentVersion {
    /**
     * Используется `context_v1.Context` в качестве модели контекста.
     * Содержимое представлено согласно thrift strict binary encoding.
     */
    v1_thrift_binary
}

/**
 * Модель непрозрачного для клиентов фрагмента контекста для принятия решений.
 *
 * Непрозрачность здесь введена с целью минимизировать количество сервисов,
 * которые необходимо будет обновлять при изменении модели контекста, например
 * в случае добавления новых атрибутов.
 */
struct ContextFragment {
    1: required ContextFragmentVersion version
    2: optional binary content
}

/**
 * Контекст для принятия решений
 */
struct Context {
    1: required list<ContextFragment> fragments
}

/// Сервис принятия решений вида «можно» / «нельзя»

/** Идентификатор свода правил. */
typedef string RulesetID

enum Resolution {
    allowed
    forbidden
}

/** Принятое решение. */
struct Judgement {
    1: required Resolution resolution
    2: optional list<Assertion> assertions
}

/** Пояснение к решению, с машиночитаемым кодом для классификации. */
struct Assertion {
    1: required string code
    2: optional string description
}

exception RulesetNotFound {}

service Arbiter {

    Judgement Judge (1: RulesetID ruleset, 2: Context ctx) throws (
        1: RulesetNotFound ex1
    )

}
