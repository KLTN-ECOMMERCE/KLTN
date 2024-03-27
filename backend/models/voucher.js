import mongoose from 'mongoose'

const voucherSchema = mongoose.Schema({
  // user: {
  //   type: mongoose.Schema.Types.ObjectId,
  //   //required: true,
  //   ref: 'User',
  // },
  description: {
    type: String,
    required: true,
  },
  deliveryFee: {
    type: Boolean,
    required: true,
  },
  discount: {
    type: Number,
    required: true,
  },
})
export default mongoose.model('Voucher', voucherSchema)
