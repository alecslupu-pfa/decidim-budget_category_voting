# frozen_string_literal: true
#
# {
#   "authenticity_token" => "[FILTERED]",
#   "component" => {
#     "name_en" => "Budgets",
#     "name_ca" => "Pressupostos",
#     "name_es" => "Presupuestos",
#     "weight" => "0",
#     "settings" => {
#       "scopes_enabled" => "0",
#       "workflow" => "random",
#       "projects_per_page" => "12",
#       "vote_rule_threshold_percent_enabled" => "0",
#       "vote_threshold_percent" => "70",
#       "vote_rule_minimum_budget_projects_enabled" => "0",
#       "vote_minimum_budget_projects_number" => "1",
#       "vote_rule_selected_projects_enabled" => "0",
#       "vote_selected_projects_minimum" => "0",
#       "vote_selected_projects_maximum" => "1",
#       "comments_enabled" => "1",
#       "comments_max_length" => "0",
#       "geocoding_enabled" => "0",
#       "resources_permissions_enabled" => "1",
#       "announcement_en" => "",
#       "announcement_ca" => "",
#       "announcement_es" => "",
#       "landing_page_content_en" =>"<h2>Modi architecto voluptate provident.</h2><p>In dolor quo. Est labore rerum. Dicta molestias earum.</p><p>Ut magni itaque. Quaerat omnis rerum. Quos necessitatibus qui.</p>",
#       "landing_page_content_ca" => "<h2>Similique aut maxime velit.</h2><p>Voluptas at dolores. Voluptatem aperiam quaerat. Ut quo repellat.</p><p>Molestiae fugit et. Autem architecto impedit. Doloremque rerum enim.</p>",
#       "landing_page_content_es" => "",
#       "more_information_modal_en" => "Aut enim nostrum. Excepturi aut eum. Blanditiis nihil consequatur. Natus et earum.",
#       "more_information_modal_ca" => "Officiis illum numquam. Sit dolorem omnis. Autem aut expedita. Molestiae reprehenderit quidem.",
#       "more_information_modal_es" => "",
#       "vote_rule_category_voting_enabled" => "1"
#     },
#     "step_settings" => {
#       "1" => {
#         "comments_blocked" => "0",
#         "votes" => "enabled",
#         "show_votes" => "0",
#         "announcement_en" => "",
#         "announcement_ca" => "",
#         "announcement_es" => "",
#         "landing_page_content_en" => "",
#         "landing_page_content_ca" => "",
#         "landing_page_content_es" => "",
#         "more_information_modal_en" => "",
#         "more_information_modal_ca" => "",
#         "more_information_modal_es" => ""
#       }
#     }
#   },
#   "categories" => {
#     "7" => { "value" => "3", "id" => "7", "position" => "0", "deleted" => "false" },
#         "8" => { "value" => "4", "id" => "8", "position" => "1", "deleted" => "false" },
#         "6" => { "value" => "5", "id" => "6", "position" => "2", "deleted" => "false" },
#         "5" => { "value" => "6", "id" => "5", "position" => "3", "deleted" => "false" },
#     "4" => { "value" => "0", "id" => "4", "position" => "4", "deleted" => "false" },
#     "3" => { "value" => "0", "id" => "3", "position" => "5", "deleted" => "false" },
#                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "2" => { "value" => "0", "id" => "2", "position" => "6", "deleted" => "false" },
#                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "1" => { "value" => "0", "id" => "1", "position" => "7", "deleted" => "false" } },
#   "participatory_process_slug" => "relationship-curriculum",
#   "id" => "3"
# }

module Decidim::BudgetCategoryVoting::Overrides::ComponentForm
  extend ActiveSupport::Concern

  included do
    attribute :vote_category_voting, Array[Decidim::BudgetCategoryVoting::Admin::CategoryForm]
    attribute :blank_vote_category_voting, Decidim::BudgetCategoryVoting::Admin::CategoryForm

    validate :vote_category_voting
    validate :budget_voting_rule_category_value_setting

    def map_model(model)
      super(model)

      self.blank_vote_category_voting = Decidim::BudgetCategoryVoting::Admin::CategoryForm.new

      self.vote_category_voting = avaliable_categories(model).each do |category|
        Decidim::BudgetCategoryVoting::Admin::CategoryForm.new(category)
      end
    end

    def avaliable_categories(model)
      return @avaliable_categories if defined?(@avaliable_categories)

      @avaliable_categories = {}

      if model.settings.vote_category_voting.present?
        model.settings.vote_category_voting.each do |category|
          @avaliable_categories[category["decidim_category_id"]] = category
        end
      end

      model.participatory_space.categories.where(id: @avaliable_categories.keys).each do |a|
        @avaliable_categories[a.id.to_s] ||= {}
        @avaliable_categories[a.id.to_s].merge!("name" => a.name)
      end

      @avaliable_categories = @avaliable_categories.values
      @avaliable_categories.each { |c| c.transform_keys!(&:to_sym) }
    end

    def budget_voting_rule_category_value_setting
      return unless manifest&.name == :budgets
      return unless settings.vote_rule_category_voting_enabled

      vote_category_voting.each do |category|
        next if category.deleted

        invalid_category_number = category.value.blank? || category.value.to_i.negative?
        category.errors.add(:value) if invalid_category_number
      end
    end

    def budget_voting_rule_enabled_setting
      return unless manifest&.name == :budgets

      rule_settings = [
        :vote_rule_threshold_percent_enabled,
        :vote_rule_minimum_budget_projects_enabled,
        :vote_rule_selected_projects_enabled,
        :vote_rule_category_voting_enabled
      ]
      active_rules = rule_settings.select { |key| settings.public_send(key) == true }
      i18n_error_scope = "decidim.components.budgets.settings.global.form.errors"
      if active_rules.blank?
        rule_settings.each do |key|
          settings.errors.add(key, I18n.t(:budget_voting_rule_required, scope: i18n_error_scope))
        end
      end

      if active_rules.length > 1
        rule_settings.each do |key|
          settings.errors.add(key, I18n.t(:budget_voting_rule_only_one, scope: i18n_error_scope))
        end
      end
    end
  end
end
