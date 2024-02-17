export default class FieldTogglerComponent {
    constructor(options = {}) {
        this.toggleSelector = options.toggleSelector;
        this.containerSelector = options.containerSelector;
        this.run();
    }

    run() {
        const self = this;
        const selector = `${this.toggleSelector}:not([data-has-toggle=true])`;

        document.querySelectorAll(selector).forEach(function (el) {
            el.addEventListener("change", (e) => {
                self.toggleBudgetFields(e.target)
            });
            self.toggleBudgetFields(el);
        });
    }

    toggleBudgetFields(el) {
        if (el.value === "") return;

        el.dataset.hasToggle = true;
        const parent = el.closest(this.containerSelector);
        parent.querySelectorAll(`[data-toggle-field][data-toggle=${el.value}]`).forEach((el) => el.style.display = "block");
        parent.querySelectorAll(`[data-toggle-field]:not([data-toggle=${el.value}])`).forEach((el) => el.style.display = "none");
    }
}