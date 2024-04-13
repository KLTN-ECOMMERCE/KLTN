import express from "express";
const router = express.Router();
import { authorizeRoles, isAuthenticatedUser } from "../middlewares/auth.js";
import {
  createShippingInfo,
  getShippingInfo,
  deleteAddressInfo,
  updateAddressInfo,
  addressDefault,
  getAddressDefault,
} from "../controllers/addressControllers.js";
router
  .route("/me/createShippingInfo")
  .post(isAuthenticatedUser, createShippingInfo);
router.route("/me/getShippingInfo").get(isAuthenticatedUser, getShippingInfo);
router
  .route("/me/deleteShippingInfo/:addressId")
  .delete(isAuthenticatedUser, deleteAddressInfo);
router
  .route("/me/updateShippingInfo/:addressId")
  .put(isAuthenticatedUser, updateAddressInfo);
router.route("/me/addressDefault/:id").get(isAuthenticatedUser, addressDefault);
router
  .route("/me/getAddressDefault")
  .get(isAuthenticatedUser, getAddressDefault);
export default router;
