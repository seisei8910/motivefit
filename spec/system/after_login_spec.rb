require 'rails_helper'

describe 'ユーザログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザーログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it '投稿一覧を押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[1].text
        posts_link = posts_link.gsub(/\n/, '').strip
        click_link posts_link
        is_expected.to eq '/posts'
      end
      it 'マイページを押すと、マイページ画面に遷移する' do
        mypage_link = find_all('a')[2].text
        mypage_link = mypage_link.gsub(/\n/, '').strip
        click_link mypage_link
        is_expected.to eq '/mypage'
      end
      it 'メッセージを押すと、ルーム一覧画面に遷移する' do
        rooms_link = find_all('a')[3].text
        rooms_link = rooms_link.gsub(/\n/, '').strip
        click_link rooms_link
        is_expected.to eq '/rooms'
      end
      it '新規投稿を押すと、新規投稿画面に遷移する' do
        posts_new_link = find_all('a')[4].text
        posts_new_link = posts_new_link.gsub(/\n/, '').strip
        click_link posts_new_link, match: :first
        is_expected.to eq '/posts/new'
      end
    end
  end
end