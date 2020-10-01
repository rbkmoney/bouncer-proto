namespace java com.rbkmoney.bouncer.decisions
namespace erlang bdcs

include "context.thrift"

typedef string ContextFragmentID

/**
 * Контекст для принятия решений
 */
struct Context {
    1: required map<ContextFragmentID, context.ContextFragment> fragments
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
    // TODO
    // Опять же любопытно: нужны ли здесь какие-то детали принятых решений? Или мы всё же
    // предполагаем, что с деталями клиенту всё равно делать нечего, и соостветсвенно для
    // исключения возможности утечки их пользователю (потенциальному злоумышленнику) разумнее
    // их не отдавать, а только лишь писать в аудит-лог?
    2: optional list<Assertion> assertions
}

/** Пояснение к решению, с машиночитаемым кодом для классификации. */
struct Assertion {
    1: required string code
    2: optional string description
}

exception RulesetNotFound {}
exception InvalidRuleset {}

// TODO
// Пока без лишних деталей. Надо бы понять, нужны ли они клиенту.
// Предполагается, что в аудит-лог детали подобной ошибки всё же попадают.
exception InvalidContext {}

service Arbiter {

    Judgement Judge (1: RulesetID ruleset, 2: Context ctx) throws (
        1: RulesetNotFound ex1
        2: InvalidRuleset ex2
        3: InvalidContext ex3
    )

}
