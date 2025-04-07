# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:post)).to be_valid
    end
  end
  context '空白のバリデーションチェック' do
    it 'titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか' do
      post = Post.new(title: '', start_time: DateTime.now)
      expect(post).to be_invalid
      expect(post.errors.full_messages).to include("タイトルを入力してください")
    end
    it 'bodyが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか' do
      post = Post.new(title: 'hoge', start_time: '')
      expect(post).to be_invalid
      expect(post.errors.full_messages).to include("フィットネスを行なった日を入力してください")
    end
  end
end