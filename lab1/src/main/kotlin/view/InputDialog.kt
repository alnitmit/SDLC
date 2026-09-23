import java.awt.GridLayout
import java.awt.event.ActionListener
import javax.swing.*

class InputDialog(parent: JFrame, controller: LazinessController) : JDialog(parent, "Настройка параметров", true) {
    private val txtPlanned = JTextField(7)
    private val txtCompleted = JTextField(7)

    init {
        setSize(320, 180)
        setLocationRelativeTo(parent)
        layout = GridLayout(3, 2, 12, 12)
        (contentPane as JPanel).border = BorderFactory.createEmptyBorder(15, 15, 15, 15)

        add(JLabel(" Запланировано:"))
        add(txtPlanned)
        add(JLabel(" Выполнено:"))
        add(txtCompleted)

        val btnSubmit = JButton("Рассчитать")
        add(JLabel()) // Пустая ячейка для сетки
        add(btnSubmit)

        val submitAction = ActionListener {
            controller.processInput(txtPlanned.text, txtCompleted.text)
        }

        btnSubmit.addActionListener(submitAction)
        // Поддержка клавиши Enter в каждом поле
        txtPlanned.addActionListener(submitAction)
        txtCompleted.addActionListener(submitAction)
    }

    fun setValues(planned: Int, completed: Int) {
        if (planned > 0) {
            txtPlanned.text = planned.toString()
            txtCompleted.text = completed.toString()
        }
    }
}