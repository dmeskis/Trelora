require 'rails_helper'

feature 'user can submit home form' do
  scenario 'user fills out forms and submits them' do
    user = User.create(name: "steve", email: "steven@trel.co", HTTP_AUTH_TOKEN: "this_is_a_very_simple_auth_token_string")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    # Sets session address
    visit '/find'
    fill_in :address, with: "1860_south_marion_street-Denver-CO-80210"
    click_on "Find Location"

    visit collect_path

    expect(page).to have_content('Begin The Listing Consultation')
    click_on 'Start'
    fill_in :about_the_home, with: "A home"
    fill_in :recommended_list_price, with: "100000"
    fill_in :update_client_enthusiasm, with: "Stoked"
    fill_in :buyer_agent_commission, with: "500"
    fill_in :about_the_seller, with: "Total dick"
    fill_in :credit_card_number, with: "347881974288396"
    fill_in :credit_card_expiration_date, with: "2020-09-15"
    click_on "Finish"
    expect(current_path).to eq(collect_path)
    expect(page).to have_content("Listing Consultation Complete")
    click_on "Dismiss"
    expect(page).to have_button('Start', disabled: true)
    # NEED TO MAKE THIS MORE COMPREHENSIVE
  end
  scenario 'user fills out wrong form information' do
    user = User.create(name: "steve", email: "steven@trel.co", HTTP_AUTH_TOKEN: "this_is_a_very_simple_auth_token_string")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    # Sets session address
    visit '/find'
    fill_in :address, with: "1860_south_marion_street-Denver-CO-80210"
    click_on "Find Location"

    visit collect_path
    expect(page).to have_content('Begin The Listing Consultation')
    click_on 'Start'
    fill_in :about_the_home, with: "A home"
    fill_in :recommended_list_price, with: "100000"
    fill_in :update_client_enthusiasm, with: "Stoked"
    fill_in :buyer_agent_commission, with: "500"
    fill_in :about_the_seller, with: "Hot"
    fill_in :credit_card_number, with: "3478396"
    fill_in :credit_card_expiration_date, with: "2020-09-15"
    click_on "Finish"
    expect(page).to have_content("Invalid form data.")
  end
end
