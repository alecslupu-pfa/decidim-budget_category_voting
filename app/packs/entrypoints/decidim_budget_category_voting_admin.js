// Images
require.context("../images", true)

import AutoButtonsByPositionComponent from "src/decidim/admin/auto_buttons_by_position.component"
import AutoLabelByPositionComponent from "src/decidim/admin/auto_label_by_position.component"
import createDynamicFields from "src/decidim/admin/dynamic_fields.component"
import createSortList from "src/decidim/admin/sort_list.component"
import FieldTogglerComponent from "src/decidim/budget_category_voting/admin/field_toggler.component"

$(() => {
    const dynamicFieldDefinitions = [
        {
            placeHolderId: "blank_vote_category_voting",
            wrapperSelector: ".budget-category-votings",
            fieldSelector: ".budget-category-voting",
            addFieldSelector: ".add-budget-category-voting"
        }
    ];

    dynamicFieldDefinitions.forEach((section) => {
        const fieldSelectorSuffix = section.fieldSelector.replace(".", "");

        const fieldToggler = new FieldTogglerComponent({
            containerSelector: ".budget-category-voting",
            toggleSelector: ".budget-category-criteria"
        });

        const autoButtonsByPosition = new AutoButtonsByPositionComponent({
            listSelector: `${section.fieldSelector}:not(.hidden)`,
            hideOnFirstSelector: ".move-up-question",
            hideOnLastSelector: ".move-down-question"
        });

        const autoLabelByPosition = new AutoLabelByPositionComponent({
            listSelector: `${section.fieldSelector}:not(.hidden)`,
            labelSelector: ".card-title span:first",
            onPositionComputed: (el, idx) => {
                $(el).find("input[name$=\\[position\\]]").val(idx);
            }
        });

        const createSortableList = () => {
            createSortList(".decidim-budget-category-voting-list:not(.published)", {
                handle: ".budget-category-voting-divider",
                placeholder: '<div style="border-style: dashed; border-color: #000"></div>',
                forcePlaceholderSize: true,
                onSortUpdate: () => {
                    autoLabelByPosition.run();
                    autoButtonsByPosition.run();
                }
            });
        };

        const hideDeletedItem = ($target) => {
            const inputDeleted = $target.find("input[name$=\\[deleted\\]]").val();

            if (inputDeleted === "true") {
                $target.addClass("hidden");
                $target.hide();

                // Allows re-submitting of the form
                $("input", $target).removeAttr("required");
            }
        };

        createDynamicFields({
            placeholderId: section.placeHolderId,
            wrapperSelector: section.wrapperSelector,
            containerSelector: `${section.wrapperSelector}-list`,
            fieldSelector: section.fieldSelector,
            addFieldButtonSelector: section.addFieldSelector,
            removeFieldButtonSelector: `.remove-${fieldSelectorSuffix}`,
            moveUpFieldButtonSelector: ".move-up-question",
            moveDownFieldButtonSelector: ".move-down-question",
            onAddField: () => {
                createSortableList();

                autoLabelByPosition.run();
                autoButtonsByPosition.run();
                fieldToggler.run();
            },
            onRemoveField: ($field) => {
                autoLabelByPosition.run();
                autoButtonsByPosition.run();

                // Allows re-submitting of the form
                $("input", $field).removeAttr("required");
            },
            onMoveUpField: () => {
                autoLabelByPosition.run();
                autoButtonsByPosition.run();
            },
            onMoveDownField: () => {
                autoLabelByPosition.run();
                autoButtonsByPosition.run();
            }
        });

        createSortableList();

        $(section.fieldSelector).each((_idx, el) => {
            const $target = $(el);

            hideDeletedItem($target);
        });

        autoLabelByPosition.run();
        autoButtonsByPosition.run();
        fieldToggler.run();
    });
});