package de.keller.physioai.shared

import io.mockk.CapturingMatcher
import io.mockk.CapturingSlot
import io.mockk.ConstantMatcher
import io.mockk.EquivalentMatcher
import io.mockk.Matcher
import io.mockk.MockKGateway
import io.mockk.MockKMatcherScope
import io.mockk.TypedMatcher
import kotlin.reflect.KClass
import kotlin.reflect.KFunction
import kotlin.reflect.full.primaryConstructor
import kotlin.reflect.jvm.isAccessible

inline fun <reified T : Any> MockKMatcherScope.anyValue(): T {
    if (!T::class.isValue) return any()

    val constructor = T::class.primaryConstructor!!.apply { isAccessible = true }
    val rawType = constructor.parameters[0].type.classifier as KClass<*>

    val anyRawValue = callRecorder.matcher(ConstantMatcher<T>(true), rawType)
    return constructor.call(anyRawValue)
}

inline fun <reified T : Any> MockKMatcherScope.captureValue(slot: CapturingSlot<T>): T {
    if (!T::class.isValue) return capture(slot)

    val constructor = T::class.primaryConstructor!!.apply { isAccessible = true }
    val rawType = constructor.parameters[0].type.classifier as KClass<*>

    val anyRawValue = callRecorder.matcher(CapturingValueSlotMatcher(slot, constructor, rawType), rawType)
    return constructor.call(anyRawValue)
}

val MockKMatcherScope.callRecorder: MockKGateway.CallRecorder
    get() = getProperty("callRecorder") as MockKGateway.CallRecorder

data class CapturingValueSlotMatcher<T : Any>(
    val captureSlot: CapturingSlot<T>,
    val valueConstructor: KFunction<T>,
    override val argumentType: KClass<*>,
) : Matcher<T>,
    CapturingMatcher,
    TypedMatcher,
    EquivalentMatcher {
    override fun equivalent(): Matcher<Any> = ConstantMatcher(true)

    @Suppress("UNCHECKED_CAST")
    override fun capture(arg: Any?) {
        if (arg == null) {
            captureSlot.isNull = true
        } else {
            captureSlot.isNull = false
            captureSlot.captured = valueConstructor.call(arg)
        }
        captureSlot.isCaptured = true
    }

    override fun match(arg: T?): Boolean = true

    override fun toString(): String = "slotCapture<${argumentType.simpleName}>()"
}
