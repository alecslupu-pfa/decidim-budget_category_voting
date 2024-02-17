# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Admin
      class CategoryForm < Form
        include TranslatableAttributes

        translatable_attribute :name, String

        attribute :decidim_category_id, Integer
        attribute :minimum, Integer, default: 0
        attribute :maximum, Integer, default: 0
        attribute :percentage, Integer, default: 0
        attribute :position, Integer
        attribute :color, String
        attribute :deleted, Boolean, default: false
        attribute :criteria, String
        attribute :projects_number, Integer

        validates :category, presence: true, if: ->(form) { form.decidim_category_id.present? }, unless: :deleted

        validate :budget_voting_rule_threshold_value_setting,
                 :budget_voting_rule_minimum_value_setting,
                 :budget_voting_rule_projects_value_setting, unless: :deleted

        def to_param
          return id if id.present?

          "category-id"
        end

        delegate :categories, to: :current_participatory_space

        def criteria_select
          rule_settings = [
            :vote_rule_threshold_percent_enabled,
            :vote_rule_minimum_budget_projects_enabled,
            :vote_rule_selected_projects_enabled
          ]

          rule_settings.map do |type|
            [ I18n.t(type, scope: "decidim.components.budgets.settings.global"), type ]
          end
        end

        def category
          return unless current_participatory_space

          @category ||= categories.find_by(id: decidim_category_id)
        end

        protected

        # - the value must be a valid number
        def budget_voting_rule_threshold_value_setting
          return unless criteria == "vote_rule_threshold_percent_enabled"

          invalid_percent_number = precentage.blank? || precentage.to_i.negative?
          errors.add(:precentage) if precentage
        end

        def budget_voting_rule_minimum_value_setting
          return unless criteria == "vote_rule_minimum_budget_projects_enabled"

          invalid_minimum_number = projects_number.blank? || (projects_number.to_i < 1)
          errors.add(:projects_number) if invalid_minimum_number
        end

        def budget_voting_rule_projects_value_setting
          return unless criteria == "vote_rule_selected_projects_enabled"

          budget_voting_projects_value_setting_min
          budget_voting_projects_value_setting_max
          budget_voting_projects_value_setting_both
        end

        def budget_voting_projects_value_setting_min
          return if minimum.present? && minimum.to_i >= 0

          errors.add(:minimum)
        end

        def budget_voting_projects_value_setting_max
          return if maximum.present? && maximum.to_i.positive?

          errors.add(:maximum)
        end

        def budget_voting_projects_value_setting_both
          return if errors[:minimum].present?
          return if errors[:maximum].present?
          return if maximum >= minimum

          errors.add(:minimum)
          errors.add(:maximum)
        end

      end
    end
  end
end
