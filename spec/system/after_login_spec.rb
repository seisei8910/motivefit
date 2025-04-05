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

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人の投稿のアイコン画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
        expect(page).to have_link '', href: user_path(other_post.user)
      end
      it '自分と他人の投稿の名前のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
        expect(page).to have_link other_post.user.name, href: user_path(other_post.user)
      end
      it '自分と他人の投稿の日付のリンク先が正しい' do
        expect(page).to have_link post.start_time.strftime("%Y年%m月%d日"), href: post_path(post)
        expect(page).to have_link other_post.start_time.strftime("%Y年%m月%d日"), href: post_path(other_post)
      end
      it '自分と他人の投稿のタイトルのリンク先が正しい' do
        expect(page).to have_link post.title, href: post_path(post)
        expect(page).to have_link other_post.title, href: post_path(other_post)
      end
      it '自分と他人の投稿のメニューのリンク先が正しい' do
        expect(page).to have_link post.menu, href: post_path(post)
        expect(page).to have_link other_post.menu, href: post_path(other_post)
      end
      it '自分と他人の投稿の感想・メモのリンク先が正しい' do
        expect(page).to have_link post.body, href: post_path(post)
        expect(page).to have_link other_post.body, href: post_path(other_post)
      end
    end
    context 'タブ表示内容の確認' do
      it '投稿一覧リンクが表示される' do
        expect(page).to have_link '投稿一覧', href: posts_path
      end
      it 'フォロー中リンクが表示される' do
        expect(page).to have_link 'フォロー中', href: follow_feed_path
      end
      it 'いいねリンクが表示される' do
        expect(page).to have_link 'いいね', href: favorite_posts_user_path(user)
      end
    end
    context 'タブのリンク内容を確認' do
      subject { current_path }
      it '投稿一覧タブを押すと、投稿一覧に遷移する' do
        find_all('a', text: '投稿一覧')[1].click
        is_expected.to eq '/posts'
      end
      it 'フォロー中タブを押すと、投稿一覧に遷移する' do
        click_link 'フォロー中'
        is_expected.to eq '/follow_feed'
      end
      it 'いいねタブを押すと、投稿一覧に遷移する' do
        click_link 'いいね'
        is_expected.to eq '/users/' + user.id.to_s + '/favorite_posts'
      end
    end
    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.status_message
      end
      it 'フォローリンク、フォロワーリンクが表示される' do
        expect(page).to have_link 'フォロー', href: user_followings_path(user)
        expect(page).to have_link 'フォロワー', href: user_followers_path(user)
      end
      it '自分のユーザー編集画面へのリンクが存在する' do
        expect(page).to have_link 'プロフィール編集', href: edit_user_path(user)
      end
    end
  end
end