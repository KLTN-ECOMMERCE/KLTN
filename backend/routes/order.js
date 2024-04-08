import express from "express";
const router = express.Router();

import { authorizeRoles, isAuthenticatedUser } from "../middlewares/auth.js";
import {
  allOrders,
  deleteOrder,
  getOrderDetails,
  getSales,
  myOrders,
  newOrder,
  updateOrder,
  getOrderByStatus,
  cancelOrder,
  getTotalAmountByMonth,
  getDataOrderByStatus,
} from "../controllers/orderControllers.js";

router.route("/orders/new").post(isAuthenticatedUser, newOrder);
router.route("/orders/:id").get(isAuthenticatedUser, getOrderDetails);
router.route("/order/cancel/:id").post(isAuthenticatedUser, cancelOrder);
router.route("/me/orders").get(isAuthenticatedUser, myOrders);
router
  .route("/me/getAmount/:year")
  .get(isAuthenticatedUser, getTotalAmountByMonth);
// router.route("/me/getDataCategory").get(isAuthenticatedUser, getDataCategory);

router
  .route("/me/getOrderByStatus/:status")
  .get(isAuthenticatedUser, getOrderByStatus);

router
  .route("/me/getDataOrderByStatus")
  .get(isAuthenticatedUser, getDataOrderByStatus);
router
  .route("/admin/get_sales")
  .get(isAuthenticatedUser, authorizeRoles("admin"), getSales);

router
  .route("/admin/orders")
  .get(isAuthenticatedUser, authorizeRoles("admin"), allOrders);

router
  .route("/admin/orders/:id")
  .put(isAuthenticatedUser, authorizeRoles("admin"), updateOrder)
  .delete(isAuthenticatedUser, authorizeRoles("admin"), deleteOrder);

export default router;
