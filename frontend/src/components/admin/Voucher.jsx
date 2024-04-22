import React from "react";
import { useGetVoucherQuery } from "../../redux/api/voucherApi";

export const Voucher = () => {
  const { data, isLoading, error } = useGetVoucherQuery();
  console.log(data);
  return <div>Voucher</div>;
};
