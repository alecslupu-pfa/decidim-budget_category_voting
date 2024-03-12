$(() => {
    const $projects = $("#projects, #project");
    const $budgetSummaryTotal = $(".budget-summary__total");
    const $budgetExceedModal = $("#budget-excess");
    const $budgetSummary = $(".budget-summary__progressbox");
    const $voteButton = $(".budget-vote-button");
    const totalAllocation = parseInt($budgetSummaryTotal.attr("data-total-allocation"), 10);

    const cancelEvent = (event) => {
        $(event.currentTarget).removeClass("loading-spinner");
        event.stopPropagation();
        event.preventDefault();
    };

    $voteButton.on("click", "span", () => {
        $(".budget-list__action").click();
    });

    $projects.on("click", ".budget-list__action", (event) => {
        const currentAllocation = parseInt($budgetSummary.attr("data-current-allocation"), 10);
        const $currentTarget = $(event.currentTarget);
        const projectAllocation = parseInt($currentTarget.attr("data-allocation"), 10);

        if (!$currentTarget.attr("data-open")) {
            $currentTarget.addClass("loading-spinner");
        }

        const $targetCategoryId = $currentTarget.parents(".budget-list__data").first().data("category");
        const $targetCategory = $(`.vote_by_category[data-category=${$targetCategoryId}]`).first();
        const $budgetCategoryExceedModal = $(`#budget-excess-${$targetCategoryId}`);

        let quotaExceeded = ((currentAllocation + projectAllocation) > totalAllocation);
        let categoryQuotaExceeded = false;

        if ($targetCategory.length > 0) {
            const currentCategoryAllocation = parseInt($targetCategory.attr("data-current-allocation"), 10);
            const totalCategoryAllocation = parseInt($targetCategory.attr("data-total-allocation"), 10);
            categoryQuotaExceeded = ((currentCategoryAllocation + projectAllocation) > totalCategoryAllocation || quotaExceeded);
        }

        if ($currentTarget.attr("disabled")) {
            cancelEvent(event);
        } else if (($currentTarget.attr("data-add") === "true") && categoryQuotaExceeded === true) {
            $budgetCategoryExceedModal.foundation("toggle");
            cancelEvent(event);
        } else if (($currentTarget.attr("data-add") === "true") && quotaExceeded === true) {
            $budgetExceedModal.foundation("toggle");
            cancelEvent(event);
        }
    });
});