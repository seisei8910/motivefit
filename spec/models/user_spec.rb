# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, "モデルに関するテスト", type: :model do
  describe "実際に新規登録してみる" do
    it "有効な場合は新規登録されるか" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end
  context "バリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      user = User.new(name: "", email: Faker::Internet.email,
      password: Faker::Internet.password(min_length: 6), password_confirmation: "password")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include("名前を入力してください")
    end
    it "nameが50文字以上の場合にバリデーションチェックされエラーメッセージが返ってきているか" do
      user = User.new(name: "あ" * 51, email: Faker::Internet.email,
      password: Faker::Internet.password(min_length: 6), password_confirmation: "password")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include("名前は50文字以内で入力してください")
    end
    it "nameが不正な文字の場合にバリデーションチェックされエラーメッセージが返ってきているか" do
      user = User.new(name: '/\A[^\d`!@#$%\^&*+_=]+\z/', email: Faker::Internet.email,
      password: Faker::Internet.password(min_length: 6), password_confirmation: "password")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include("名前に不正な文字が含まれています")
    end
    it "emailが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      user = User.new(name: Faker::Name.name, email: "",
      password: Faker::Internet.password(min_length: 6), password_confirmation: "password")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include("Eメールを入力してください")
    end
    it "emailが重複する場合にバリデーションチェックされエラーメッセージが返ってきているか" do
      user = FactoryBot.create(:user)
      another_user = FactoryBot.build(:user)
      another_user.email = user.email
      expect(another_user).to be_invalid
      expect(another_user.errors.full_messages).to include("Eメールはすでに存在します")
    end
    it "パスワードが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      user = User.new(name: Faker::Name.name, email: Faker::Internet.email,
      password: "", password_confirmation: "password")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include("パスワードを入力してください")
    end
    it "パスワードが５文字以下の場合にバリデーションチェックされエラーメッセージが返ってきているか" do
      user = User.new(name: Faker::Name.name, email: Faker::Internet.email,
      password: "00000", password_confirmation: "password")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include("パスワードは6文字以上で入力してください")
    end
    it "パスワードの確認が一致しない場合にバリデーションチェックされエラーメッセージが返ってきているか" do
      user = User.new(name: Faker::Name.name, email: Faker::Internet.email,
      password: Faker::Internet.password(min_length: 6), password_confirmation: "")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
    end
  end
end