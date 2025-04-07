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
      it '「ゲストログイン（閲覧用）」リンクが表示される' do
        guest_log_in_link = find_all('a')[5].text
        expect(guest_log_in_link).to match(/ゲストログイン（閲覧用）/)
      end
      it '「ゲストログイン（閲覧用）」リンクの内容が正しい' do
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

  describe 'アバウト画面のテスト' do
    before do
      visit about_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end
    context '表示内容の確認' do
      it '「ロゴ」リンクが表示される' do
        expect(page).to have_selector('a.navbar-brand[href="/"]')
      end
      it '「ホーム」リンクが表示される: 左上から2番目のリンクが「ホーム」である' do
        home_link = find_all('a')[1].text
        expect(home_link).to match(/ホーム/)
      end
      it 'Aboutリンクが表示される: 左上から3番目のリンクが「このサイトについて」である' do
        about_link = find_all('a')[2].text
        expect(about_link).to match(/このサイトについて/)
      end
      it 'Sign upリンクが表示される: 左上から4番目のリンクが「Sign up」である' do
        signup_link = find_all('a')[3].text
        expect(signup_link).to match(/Sign up/)
      end
      it 'Log inリンクが表示される: 左上から5番目のリンクが「Log in」である' do
        login_link = find_all('a')[4].text
        expect(login_link).to match(/Log in/)
      end
    end
    context 'リンクの内容を確認' do
      subject {current_path}
      it '「ロゴ」を押すと、トップ画面に遷移する' do
        home_link = find_all('a')[0]
        home_link.click
        is_expected.to eq '/'
      end
      it '「ホーム」を押すと、トップ画面に遷移する' do
        home_link = find_all('a')[1].text
        home_link = home_link.delete(' ')
        home_link.gsub!(/\n/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it '「このサイトについて」を押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[2].text
        about_link = about_link.gsub(/\n/, '').strip
        click_link about_link
        is_expected.to eq '/about'
      end
      it 'Sign upを押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[3].text
        signup_link = signup_link.gsub(/\n/, '').strip
        click_link signup_link, match: :first
        is_expected.to eq '/users/sign_up'
      end
      it 'Log inを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[4].text
        login_link = login_link.gsub(/\n/, '').strip
        click_link login_link, match: :first
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「アカウントを作成」と表示される' do
        expect(page).to have_content 'アカウントを作成'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '「サインアップ」ボタンが表示される' do
        expect(page).to have_button 'サインアップ'
      end
    end
    context '新規登録成功のテスト' do
      before do
        password = Faker::Internet.password(min_length: 6)
        fill_in 'user[name]', with: Faker::Name.name
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: password
        fill_in 'user[password_confirmation]', with: password
      end
      it '正しく新規登録される' do
        expect { click_button 'サインアップ' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザのマイページになっている' do
        click_button 'サインアップ'
        expect(current_path).to eq '/mypage'
      end
    end
  end

  describe 'ユーザログインのテスト' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it '「ログイン」ボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it 'nameフォームは表示されない' do
        expect(page).not_to have_field 'user[name]'
      end
    end
    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end
      it 'ログイン後のリダイレクト先が、ログインしたユーザのマイページになっている' do
        expect(current_path).to eq '/mypage'
      end
    end
    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end
      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end
    context 'ヘッダーの表示を確認' do
      it '「ロゴ」リンクが表示される' do
        expect(page).to have_selector('a.navbar-brand[href="/"]')
      end
      it '「投稿一覧」リンクが表示される' do
        posts_link = find_all('a')[1].text
        expect(posts_link).to match(/投稿一覧/)
      end
      it '「マイページ」リンクが表示される' do
        mypage_link = find_all('a')[2].text
        expect(mypage_link).to match(/マイページ/)
      end
      it '「通知」ボタンが表示される' do
        expect(page).to have_button('通知')
      end
      it '「メッセージ」リンクが表示される' do
        rooms_link = find_all('a')[3].text
        expect(rooms_link).to match(/メッセージ/)
      end
      it '「新規投稿」リンクが表示される' do
        posts_new_link = find_all('a')[4].text
        expect(posts_new_link).to match(/新規投稿/)
      end
      it 'Log outリンクが表示される' do
        logout_link = find_all('a')[5].text
        expect(logout_link).to match(/Log out/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[5].text
      logout_link = logout_link.gsub(/\n/, '').strip
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、About画面になっている' do
        expect(current_path).to eq '/about'
      end
    end
  end
end