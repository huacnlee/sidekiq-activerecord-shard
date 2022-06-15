class IntegrationTest < ActionDispatch::IntegrationTest
  test "Post create" do
    post = Post.create!(title: "Title in primary")
  end
end
