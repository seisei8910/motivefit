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

      it '「投稿一覧」を押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[1].text
        posts_link = posts_link.gsub(/\n/, '').strip
        click_link posts_link
        is_expected.to eq '/posts'
      end
      it '「マイページ」を押すと、マイページ画面に遷移する' do
        mypage_link = find_all('a')[2].text
        mypage_link = mypage_link.gsub(/\n/, '').strip
        click_link mypage_link
        is_expected.to eq '/mypage'
      end
      it '「メッセージ」を押すと、ルーム一覧画面に遷移する' do
        rooms_link = find_all('a')[3].text
        rooms_link = rooms_link.gsub(/\n/, '').strip
        click_link rooms_link
        is_expected.to eq '/rooms'
      end
      it '「新規投稿」を押すと、新規投稿画面に遷移する' do
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
      it 'ロゴと自分と他人のアイコン画像と投稿画像が表示される: fallbackの画像がヘッダーとフッターのロゴ2つ+サイドバーの1つ+一覧(アイコン)の2つ+一覧(投稿)の2つの計7つ存在する' do
        expect(all('img').size).to eq(7)
      end
      it '自分と他人の投稿のアイコン画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
        expect(page).to have_link '', href: user_path(other_post.user)
      end
      it '自分と他人の投稿の「名前」のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
        expect(page).to have_link other_post.user.name, href: user_path(other_post.user)
      end
      it '自分と他人の投稿の「日付」のリンク先が正しい' do
        expect(page).to have_link post.start_time.strftime("%Y年%m月%d日"), href: post_path(post)
        expect(page).to have_link other_post.start_time.strftime("%Y年%m月%d日"), href: post_path(other_post)
      end
      it '自分と他人の投稿の「タイトル」のリンク先が正しい' do
        expect(page).to have_link post.title, href: post_path(post)
        expect(page).to have_link other_post.title, href: post_path(other_post)
      end
      it '自分と他人の投稿の「メニュー」のリンク先が正しい' do
        expect(page).to have_link post.menu, href: post_path(post)
        expect(page).to have_link other_post.menu, href: post_path(other_post)
      end
      it '自分と他人の投稿の「感想・メモ」のリンク先が正しい' do
        expect(page).to have_link post.body, href: post_path(post)
        expect(page).to have_link other_post.body, href: post_path(other_post)
      end
    end
    context 'タブ表示内容の確認' do
      it '「投稿一覧」リンクが表示される' do
        expect(page).to have_link '投稿一覧', href: posts_path
      end
      it '「フォロー中」リンクが表示される' do
        expect(page).to have_link 'フォロー中', href: follow_feed_path
      end
      it '「いいね」リンクが表示される' do
        expect(page).to have_link 'いいね', href: favorite_posts_user_path(user)
      end
    end
    context 'タブのリンク内容を確認' do
      subject { current_path }
      it '「投稿一覧」タブを押すと、投稿一覧に遷移する' do
        find_all('a', text: '投稿一覧')[1].click
        is_expected.to eq '/posts'
      end
      it '「フォロー中」タブを押すと、投稿一覧に遷移する' do
        click_link 'フォロー中'
        is_expected.to eq '/follow_feed'
      end
      it '「いいね」タブを押すと、投稿一覧に遷移する' do
        click_link 'いいね'
        is_expected.to eq '/users/' + user.id.to_s + '/favorite_posts'
      end
    end
    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.status_message
      end
      it '「フォロー」リンク、「フォロワー」リンクが表示される' do
        expect(page).to have_link 'フォロー', href: user_followings_path(user)
        expect(page).to have_link 'フォロワー', href: user_followers_path(user)
      end
      it '自分のユーザー編集画面へのリンクが存在する' do
        expect(page).to have_link 'プロフィール編集', href: edit_user_path(user)
      end
    end
  end

  describe '新規投稿画面のテスト' do
    before do
      visit new_post_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/new'
      end
      it '「投稿フォーム」と表示される' do
        expect(page).to have_content '投稿フォーム'
      end
      it '「フィットネスを行なった日」フォームが表示される' do
        expect(page).to have_field 'post[start_time]'
      end
      it '「フィットネスを行なった日」フォームに値が入っていない' do
        expect(find_field('post[start_time]').value).to be_blank
      end
      it '「タイトル」フォームが表示される' do
        expect(page).to have_field 'post[title]'
      end
      it '「タイトル」フォームに値が入っていない' do
        expect(find_field('post[title]').value).to be_blank
      end
      it '「メニュー」フォームが表示される' do
        expect(page).to have_field 'post[menu]'
      end
      it '「メニュー」フォームに値が入っていない' do
        expect(find_field('post[menu]').value).to be_blank
      end
      it '「感想・メモ」フォームが表示される' do
        expect(page).to have_field 'post[body]'
      end
      it '「感想・メモ」フォームに値が入っていない' do
        expect(find_field('post[body]').value).to be_blank
      end
      it '「画像(任意)」フォームが表示される' do
        expect(page).to have_field 'post[image]'
      end
      it '「画像(任意)」フォームに値が入っていない' do
        expect(find_field('post[image]').value).to be_blank
      end
      it '「投稿」ボタンが表示される' do
        expect(page).to have_button '投稿'
      end
    end
    context '投稿成功のテスト' do
      before do
        fill_in 'post[start_time]', with: DateTime.now
        fill_in 'post[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'post[menu]', with: Faker::Lorem.characters(number:10)
        fill_in 'post[body]', with: Faker::Lorem.characters(number:20)
      end
      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '投稿' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button '投稿'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end
end