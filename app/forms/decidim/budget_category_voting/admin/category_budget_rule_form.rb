# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Admin
      class CategoryBudgetRuleForm < Form
        attribute :position, Integer
        attribute :deleted, Boolean, default: false

        attribute :decidim_category_id, Integer
        validates :decidim_category_id, presence: true, unless: :deleted
        attribute :vote_threshold_percent, Integer
        attribute :vote_minimum_budget_projects_number, Integer
        attribute :vote_selected_projects_minimum, Integer
        attribute :vote_selected_projects_maximum, Integer

        validate :budget_voting_rule_threshold_value_setting,
                 :budget_voting_rule_minimum_value_setting,
                 :budget_voting_rule_projects_value_setting
        def to_param
          return id if id.present?

          "budget-category-voting-id"
        end

        delegate :categories, to: :current_participatory_space
        delegate :settings, to: :current_component

        def attributes
          selected_fields = [:position, :decidim_category_id]
          if settings.vote_rule_threshold_percent_enabled
            selected_fields.push(:vote_threshold_percent)
          elsif settings.vote_rule_minimum_budget_projects_enabled
            selected_fields.push(:vote_minimum_budget_projects_number)
          elsif settings.vote_rule_selected_projects_enabled
            selected_fields.push(:vote_selected_projects_minimum, :vote_selected_projects_maximum)
          end

          super.slice(*selected_fields)
        end

        def category
          return unless current_participatory_space

          @category ||= categories.find_by(id: decidim_category_id)
        end

        protected

        def budget_voting_rule_threshold_value_setting
          return unless settings.vote_rule_threshold_percent_enabled

          invalid_percent_number = [
            vote_threshold_percent.blank?,
            vote_threshold_percent.to_i.negative?
          ].any?

          errors.add(:vote_threshold_percent) if invalid_percent_number
        end

        def budget_voting_rule_minimum_value_setting
          return unless settings.vote_rule_minimum_budget_projects_enabled

          invalid_minimum_number = [
            vote_minimum_budget_projects_number.blank?,
            vote_minimum_budget_projects_number.to_i < 1
          ].any?

          errors.add(:vote_minimum_budget_projects_number) if invalid_minimum_number
        end

        def budget_voting_rule_projects_value_setting
          return unless settings.vote_rule_selected_projects_enabled

          budget_voting_projects_value_setting_min
          budget_voting_projects_value_setting_max
          budget_voting_projects_value_setting_both
        end

        def budget_voting_projects_value_setting_min
          return if settings.vote_selected_projects_minimum.present? && settings.vote_selected_projects_minimum.to_i >= 0

          settings.errors.add(:vote_selected_projects_minimum)
        end

        def budget_voting_projects_value_setting_max
          return if settings.vote_selected_projects_maximum.present? && settings.vote_selected_projects_maximum.to_i.positive?

          settings.errors.add(:vote_selected_projects_maximum)
        end

        def budget_voting_projects_value_setting_both
          return if settings.errors[:vote_selected_projects_minimum].present?
          return if settings.errors[:vote_selected_projects_maximum].present?
          return if settings.vote_selected_projects_maximum >= settings.vote_selected_projects_minimum

          settings.errors.add(:vote_selected_projects_minimum)
          settings.errors.add(:vote_selected_projects_maximum)
        end
      end
    end
  end
end
