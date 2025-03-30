# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ゲストログイン（閲覧用）リンクが表示される' do
        guest_log_in_link = find_all('a')[5].text
        expect(guest_log_in_link).to eq('ゲストログイン（閲覧用）')
      end
      it 'ゲストログイン（閲覧用）リンクの内容が正しい' do
        guest_log_in_link = find_all('a')[5].text
        expect(page).to have_link guest_log_in_link, href: users_guest_sign_in_path
      end
      it 'Log inリンクが表示される: 青色のボタンの表示が「Log in」である' do
        log_in_link = find_all('a')[6].text
        expect(log_in_link).to match(/Log in/)
      end
      it 'Log inリンクの内容が正しい' do
        log_in_link = find_all('a')[6].text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it 'Sign upリンクが表示される: 緑色のボタンの表示が「Sign up」である' do
        sign_up_link = find_all('a')[7].text
        expect(sign_up_link).to match(/Sign up/)
      end
      it 'Sign upリンクの内容が正しい' do
        sign_up_link = find_all('a')[7].text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
    end
  end
end