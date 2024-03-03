# frozen_string_literal: true

require "spec_helper"

describe "Orders", type: :system do
  include_context "with a component"
  let(:manifest_name) { "budgets" }

  let(:organization) { create :organization, available_authorizations: %w(dummy_authorization_handler) }
  let!(:user) { create :user, :confirmed, organization: organization }
  let(:project) { projects.first }

  let!(:component) do
    create(:budgets_component,
           :with_minimum_budget_projects,
           manifest: manifest,
           participatory_space: participatory_process)
  end
  let(:minimum_to_select) { 3 }
  let(:category) { create(:category, participatory_space: component.participatory_space) }
  let(:category_budget_rules) do
    [
      { position: 0,
        decidim_category_id: category.id,
        vote_minimum_budget_projects_number: minimum_to_select }
    ]
  end
  let(:budget) { create :budget_category_voting, :with_minimum_budget_projects, component: component, category_budget_rules: category_budget_rules }

  context "when the user is not logged in" do
    let!(:projects) { create_list(:project, 1, budget: budget, budget_amount: 25_000_000) }

    it "is given the option to sign in" do
      visit_budget

      within "#project-#{project.id}-item" do
        page.find(".budget-list__action").click
      end

      expect(page).to have_css("#loginModal", visible: :visible)
    end
  end

  context "when the user is logged in" do
    let!(:projects) { create_list(:project, 3, budget: budget, category: category, budget_amount: 25_000_000) }

    before do
      login_as user, scope: :user
    end

    context "when visiting budget" do
      before do
        visit_budget
      end

      context "when voting by minimum projects number" do
        it "displays description messages" do
          within ".budget-summary" do
            expect(page).to have_content("What projects do you think we should allocate budget for? Select at least 3 projects you want and vote according to your preferences to define the budget.")
          end
        end

        it "displays rules" do
          within ".voting-rules" do
            expect(page).to have_content("Select at least 3 projects you want and vote according to your preferences to define the budget.")
          end
        end

        it "displays the category boxes" do
          expect(page).to have_selector(".column.vote_by_category", count: 1)
          within ".column.vote_by_category" do
            expect(page).to have_selector("h3", text: minimum_to_select)
            expect(page).to have_content(translated(category.name))
            expect(page).to have_content("Remaining votes")
          end
        end
      end
    end

    context "and has not a pending order" do
      before do
        visit_budget
      end

      context "when voting by minimum projects number" do
        it "adds a project to the current order" do
          within "#project-#{project.id}-item" do
            page.find(".budget-list__action").click
          end

          expect(page).to have_selector ".budget-list__data--added", count: 1

          expect(page).to have_content "ASSIGNED: €25,000,000"
          expect(page).to have_content "1 project selected"

          within ".budget-summary__selected" do
            expect(page).to have_selector(".budget-summary__selected-item", text: translated(project.title), visible: :hidden)
          end

          within "#order-progress .budget-summary__progressbox" do
            expect(page).to have_content "25%"
            expect(page).to have_selector("button.small:disabled")
          end

          expect(page).to have_selector(".column.vote_by_category", count: 1)
          within ".column.vote_by_category" do
            expect(page).to have_selector("h3", text: minimum_to_select - 1)
            expect(page).to have_content(translated(category.name))
            expect(page).to have_content("Remaining votes")
          end
        end

        it "displays total budget" do
          within ".budget-summary__total" do
            expect(page).to have_content("TOTAL BUDGET €100,000,000")
          end
        end
      end
    end

    # context "and has pending order" do
    #   let!(:order) { create(:order, user: user, budget: budget) }
    #   let!(:line_item) { create(:line_item, order: order, project: project) }
    #
    #   it "removes a project from the current order" do
    #     visit_budget
    #
    #     expect(page).to have_content "ASSIGNED: €25,000,000"
    #
    #     within "#project-#{project.id}-item" do
    #       page.find(".budget-list__action").click
    #     end
    #
    #     expect(page).to have_content "ASSIGNED: €0"
    #     expect(page).to have_no_content "1 project selected"
    #     expect(page).to have_no_selector ".budget-summary__selected"
    #
    #     within "#order-progress .budget-summary__progressbox" do
    #       expect(page).to have_content "0%"
    #     end
    #
    #     expect(page).to have_no_selector ".budget-list__data--added"
    #   end
    #
    #   it "is alerted when trying to leave the component before completing" do
    #     budget_projects_path = Decidim::EngineRouter.main_proxy(component).budget_projects_path(budget)
    #
    #     visit_budget
    #
    #     expect(page).to have_content "ASSIGNED: €25,000,000"
    #
    #     page.find(".logo-wrapper a").click
    #
    #     expect(page).to have_content "You have not yet voted"
    #
    #     click_button "Return to voting"
    #
    #     expect(page).not_to have_content("You have not yet voted")
    #     expect(page).to have_current_path budget_projects_path
    #   end
    #
    #   it "is alerted but can sign out before completing" do
    #     visit_budget
    #
    #     page.find("#user-menu-control").click
    #     page.find(".sign-out-link").click
    #
    #     expect(page).to have_content "You have not yet voted"
    #
    #     page.find("#exit-notification-link").click
    #     expect(page).to have_content("Signed out successfully")
    #   end
    #
    #   context "and try to vote a project that exceed the total budget" do
    #     let!(:expensive_project) { create(:project, budget: budget, budget_amount: 250_000_000) }
    #
    #     it "cannot add the project" do
    #       visit_budget
    #
    #       within "#project-#{expensive_project.id}-item" do
    #         page.find(".budget-list__action").click
    #       end
    #
    #       expect(page).to have_css("#budget-excess", visible: :visible)
    #     end
    #   end
    #
    #   context "and in project show page cant exceed the budget" do
    #     let!(:expensive_project) { create(:project, budget: budget, budget_amount: 250_000_000) }
    #
    #     it "cannot add the project" do
    #       page.visit Decidim::EngineRouter.main_proxy(component).budget_project_path(budget, expensive_project)
    #
    #       within "#project-#{expensive_project.id}-budget-button" do
    #         page.find("button").click
    #       end
    #
    #       expect(page).to have_css("#budget-excess", visible: :visible)
    #     end
    #   end
    #
    #   context "and add another project exceeding vote threshold" do
    #     let!(:other_project) { create(:project, budget: budget, budget_amount: 50_000_000) }
    #
    #     it "can complete the checkout process" do
    #       visit_budget
    #
    #       within "#project-#{other_project.id}-item" do
    #         page.find(".budget-list__action").click
    #       end
    #
    #       expect(page).to have_selector ".budget-list__data--added", count: 2
    #
    #       within "#order-progress .budget-summary__progressbox:not(.budget-summary__progressbox--fixed)" do
    #         page.find(".button.small").click
    #       end
    #
    #       expect(page).to have_css("#budget-confirm", visible: :visible)
    #
    #       within "#budget-confirm" do
    #         page.find(".button.expanded").click
    #       end
    #
    #       expect(page).to have_content("successfully")
    #
    #       within "#order-progress .budget-summary__progressbox" do
    #         expect(page).to have_no_selector("button.small")
    #       end
    #     end
    #   end
    #
    #   context "when the voting rule is set to minimum projects" do
    #     before do
    #       order.destroy!
    #     end
    #
    #     let!(:order_min) { create(:order, user: user, budget: budget) }
    #
    #     it "shows the rule description" do
    #       visit_budget
    #
    #       within ".card.budget-summary" do
    #         expect(page).to have_content("Select at least 3 projects you want and vote")
    #       end
    #     end
    #
    #     context "when the order total budget doesn't reach the minimum" do
    #       it "cannot vote" do
    #         visit_budget
    #
    #         within "#order-progress" do
    #           expect(page).to have_button("Vote", disabled: true)
    #         end
    #       end
    #     end
    #
    #     context "when the order total budget exceeds the minimum" do
    #       before do
    #         order_min.projects = projects
    #         order_min.save!
    #       end
    #
    #       it "can vote" do
    #         visit_budget
    #
    #         within "#order-progress" do
    #           expect(page).to have_button("Vote", disabled: false)
    #         end
    #       end
    #     end
    #   end
    # end
    #
    # context "and has a finished order" do
    #   let!(:order) do
    #     order = create(:order, user: user, budget: budget)
    #     order.projects = projects
    #     order.checked_out_at = Time.current
    #     order.save!
    #     order
    #   end
    #
    #   it "can cancel the order" do
    #     visit_budget
    #
    #     within ".budget-summary" do
    #       accept_confirm { page.find(".cancel-order").click }
    #     end
    #
    #     expect(page).to have_content("successfully")
    #
    #     within "#order-progress .budget-summary__progressbox" do
    #       expect(page).to have_selector("button.small:disabled")
    #     end
    #
    #     within ".budget-summary" do
    #       expect(page).to have_no_selector(".cancel-order")
    #     end
    #   end
    #
    #   it "is not alerted when trying to leave the component" do
    #     visit_budget
    #
    #     expect(page).to have_content("Budget vote completed")
    #
    #     page.find(".logo-wrapper a").click
    #
    #     expect(page).to have_current_path decidim.root_path
    #   end
    # end
    #
    # context "and votes are disabled" do
    #   let!(:component) do
    #     create(:budgets_component,
    #            :with_votes_disabled,
    #            manifest: manifest,
    #            participatory_space: participatory_process)
    #   end
    #
    #   it "cannot create new orders" do
    #     visit_budget
    #
    #     expect(page).to have_no_selector("button.budget-list__action")
    #   end
    # end
    #
    # context "and show votes are enabled" do
    #   let!(:component) do
    #     create(:budgets_component,
    #            :with_show_votes_enabled,
    #            manifest: manifest,
    #            participatory_space: participatory_process)
    #   end
    #
    #   let!(:order) do
    #     order = create(:order, user: user, budget: budget)
    #     order.projects = projects
    #     order.checked_out_at = Time.current
    #     order.save!
    #     order
    #   end
    #
    #   it "displays the number of votes for a project" do
    #     visit_budget
    #
    #     within "#project-#{project.id}-item .budget-list__number" do
    #       expect(page).to have_selector(".project-votes", text: "1 VOTE")
    #     end
    #   end
    # end
    #
    # context "and votes are finished" do
    #   let!(:component) do
    #     create(:budgets_component,
    #            :with_voting_finished,
    #            manifest: manifest,
    #            participatory_space: participatory_process)
    #   end
    #   let!(:projects) { create_list(:project, 2, :selected, budget: budget, budget_amount: 25_000_000) }
    #
    #   it "renders selected projects" do
    #     visit_budget
    #
    #     expect(page).to have_selector(".card__text--status.success", count: 2)
    #   end
    # end
  end

  def visit_budget
    page.visit Decidim::EngineRouter.main_proxy(component).budget_projects_path(budget)
  end
end
