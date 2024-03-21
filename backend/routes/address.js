import express from "express";
const router = express.Router();
import { authorizeRoles, isAuthenticatedUser } from "../middlewares/auth.js";
import { createShippingInfo,getShippingInfo,deleteAddressInfo,updateAddressInfo } from "../controllers/addressControllers.js";
router.route("/me/createShippingInfo").post(isAuthenticatedUser,createShippingInfo);
router.route("/me/getShippingInfo").get(isAuthenticatedUser,getShippingInfo);
router.route("/me/deleteShippingInfo/:addressId").delete(isAuthenticatedUser,deleteAddressInfo);
router.route("/me/updateShippingInfo/:addressId").put(isAuthenticatedUser,updateAddressInfo);

export default router;
