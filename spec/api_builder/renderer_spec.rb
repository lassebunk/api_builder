require 'spec_helper'

describe ApiBuilder::Renderer do

  it "can render" do
    user = OpenStruct.new(id: 1, name: "Api Builder")
    result = render("user", user: user)
    result.must_match '"id":1'
    result.must_match '"name":"Api Builder"'
  end

end