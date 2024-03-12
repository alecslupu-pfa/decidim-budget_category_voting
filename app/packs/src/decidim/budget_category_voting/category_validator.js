$(() => {
    const $projects = $("#projects, #project");
    const $budgetExceedModal = $("#budget-excess");

    const cancelEvent = (event) => {
        $(event.currentTarget).removeClass("loading-spinner");
        event.stopPropagation();
        event.preventDefault();
    };

    $projects.on("click", ".budget-list__action", (event) => {
        const $currentTarget = $(event.currentTarget);
        const projectAllocation = parseInt($currentTarget.attr("data-allocation"), 10);

        const $targetCategoryId = $currentTarget.parents(".budget-list__data").first().data("category");
        const $targetCategory = $(`.vote_by_category[data-category=${$targetCategoryId}]`).first();

        if ($targetCategory.length === 0) {
            return;
        }

        const currentAllocation = parseInt($targetCategory.attr("data-current-allocation"), 10);
        const totalAllocation = parseInt($targetCategory.attr("data-total-allocation"), 10);

        if ($currentTarget.attr("disabled")) {
            cancelEvent(event);
        } else if (($currentTarget.attr("data-add") === "true") && ((currentAllocation + projectAllocation) > totalAllocation)) {
            $budgetExceedModal.foundation("toggle");
            $budgetExceedModal.foundation("toggle");
            cancelEvent(event);
        }
    });
})