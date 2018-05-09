Mutations::UpdateAddressMutation = GraphQL::Relay::Mutation.define do
  name "UpdateAddressMutation"

  input_field :addressInput, !Types::AddressInputType  # input_fieldにTypes::AddressInputTypeを指定する

  return_field :address, !Types::AddressType

  resolve ->(_obj, inputs, ctx) {
    address_input = inputs.addressInput  # input_fieldのネストが一段深くなるので、addressInputを取り出す
    begin
      address = ctx[:current_user].address
      address.postal_code = address_input.postal_code
      address.address = address_input.address
      address.save
    rescue => e
      return GraphQL::ExecutionError.new(e.message)
    end

    { address: address }
  }
end
