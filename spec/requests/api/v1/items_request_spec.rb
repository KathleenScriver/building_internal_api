require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)
    expect(items.count).to eq(3)
  end

  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item[:id]).to eq(id)
  end

  it "can create a new item" do
    item_params = {
      name: "Apple",
      description: "An apple a day keeps the doctor away."
    }

    post "/api/v1/items", params: {item: item_params}

    item = Item.last

    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
  end

  it "can update an existing item" do
    items = create_list(:item, 3)
    id = items.last.id
    previous_name = Item.find(id).name

    new_params = {
      name: "New Banana Stand"
    }

    put "/api/v1/items/#{id}", params: {item: new_params}
    item = Item.find(id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq(new_params[:name])
  end

  it "can delete an item" do
    items = create_list(:item, 4)
    last_item = items.last

    delete "/api/v1/items/#{last_item.id}"
    new_items = Item.all

    expect(response).to be_successful
    expect(new_items.count).to eq(items.count - 1)
    expect(new_items).to_not include(last_item)
    expect{Item.find(last_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
