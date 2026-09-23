import java.util.ArrayList

class LazinessModel {
    var plannedTasks: Int = 0
        private set
    var completedTasks: Int = 0
        private set
    var lazinessRatio: Double = 0.0
        private set
    var feedbackPhrase: String = ""
        private set

    interface ModelListener {
        fun onModelChanged()
    }

    private val listeners = ArrayList<ModelListener>()

    fun addListener(listener: ModelListener) {
        listeners.add(listener)
    }

    private fun notifyListeners() {
        for (listener in listeners) {
            listener.onModelChanged()
        }
    }

    fun setData(planned: Int, completed: Int) {
        require(planned > 0) { "Число запланированных дел должно быть строго больше 0!" }
        require(completed >= 0) { "Число завершенных дел не может быть отрицательным числом!" }

        this.plannedTasks = planned
        this.completedTasks = completed

        calculateLaziness()
        notifyListeners()
    }

    private fun calculateLaziness() {
        lazinessRatio = 1.0 - (completedTasks.toDouble() / plannedTasks)
        if (lazinessRatio < 0.0) lazinessRatio = 0.0

        feedbackPhrase = when {
            lazinessRatio == 0.0 -> "Отличная работа! Лень повержена."
            lazinessRatio < 0.4 -> "Небольшая прокрастинация, но в целом неплохо."
            lazinessRatio < 0.8 -> "Лень берет верх. Пора брать себя в руки!"
            else -> "Гуру лени. Диван — ваше лучшее достижение."
        }
    }
}