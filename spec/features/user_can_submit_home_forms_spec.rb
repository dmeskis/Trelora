require 'rails_helper'

feature 'user can submit home form' do
  scenario 'user fills out forms and submits them' do
    user = User.create(name: 'steve', email: 'steven@trel.co',
                       HTTP_AUTH_TOKEN: 'this_is_a_very_simple_auth_token_string')
    addresses = [Address.new('1860_south_marion_street-Denver-CO-80210'),
                 Address.new('910-portland_place-Boulder-CO-80304')]
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:find_addresses).and_return(addresses)

    # Sets session address
    visit '/find'

    VCR.use_cassette('submit-home-passing') do
      select '1860 South Marion Street Denver Co 80210', from: :address
      click_on 'Find Location'
    end

    visit collect_path

    expect(page).to have_content('Begin The Listing Consultation')
    click_on 'Start'
    fill_in :about_the_home, with: 'A home'
    fill_in :recommended_list_price, with: '100000'
    fill_in :update_client_enthusiasm, with: 'Stoked'
    fill_in :buyer_agent_commission, with: '500'
    fill_in :about_the_seller, with: 'Excited'
    fill_in :credit_card_number, with: '347881974288396'
    select '10', from: 'date[credit_card_expiration_month]'
    select '2018', from: 'date[credit_card_expiration_year]'
    VCR.use_cassette('submit-home-finish-passing') do
      click_on 'Finish'
    end
    # save_and_open_page
    # expect(current_path).to eq(collect_path)
    # expect(page).to have_content("Listing Consultation Complete")
    # click_on "Dismiss"
    # expect(page).to have_button('Finish', disabled: true)
  end
  scenario 'user fills out wrong form information' do
    user = User.create(name: 'steve', email: 'steven@trel.co', HTTP_AUTH_TOKEN: 'this_is_a_very_simple_auth_token_string')
    addresses = [Address.new('1860_south_marion_street-Denver-CO-80210'),
                 Address.new('910-portland_place-Boulder-CO-80304')]
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:find_addresses).and_return(addresses)

    # Sets session address
    visit '/find'

    VCR.use_cassette('submit-home-failing') do
      select '1860 South Marion Street Denver Co 80210', from: :address
      click_on 'Find Location'
    end

    visit collect_path
    expect(page).to have_content('Begin The Listing Consultation')
    click_on 'Start'
    fill_in :about_the_home, with: 'A home'
    fill_in :recommended_list_price, with: '100000'
    fill_in :update_client_enthusiasm, with: 'Stoked'
    fill_in :buyer_agent_commission, with: '500'
    fill_in :about_the_seller, with: 'Hot'
    fill_in :credit_card_number, with: '3478396'
    select '10', from: 'date[credit_card_expiration_month]'
    select '2018', from: 'date[credit_card_expiration_year]'
    VCR.use_cassette('submit-home-finish-failing') do
      click_on 'Finish'
    end
    expect(page).to have_content("Invalid form data, please verify and try again.")
  end
end
