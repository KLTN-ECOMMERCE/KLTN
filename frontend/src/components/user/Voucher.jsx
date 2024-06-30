import React, { useState } from "react";
import MetaData from "../layout/MetaData";
import { useGetVoucherQuery } from "../../redux/api/voucherApi";

const Voucher = ({ setVoucher }) => {
  const { data, isLoading, error } = useGetVoucherQuery();
  const [selectedVoucher, setSelectedVoucher] = useState(null);

  const vouchers = data?.voucher || [];

  const handleVoucherClick = (voucher) => {
    setSelectedVoucher(voucher);
    setVoucher(voucher); // Update voucher in parent component
    console.log("Voucher selected:", voucher);
  };

  return (
    <>
      <MetaData title={"Voucher"} />
      <h1>Danh sách voucher</h1>
      <div className="row">
        {vouchers.map((voucher) => (
          <div
            key={voucher._id}
            className="col-sm-12 col-md-6 col-lg-3 my-3"
            onClick={() => handleVoucherClick(voucher)}
            style={{ cursor: "pointer" }}
          >
            <div
              className={`card p-3 rounded ${
                selectedVoucher?._id === voucher._id
                  ? "border border-primary"
                  : ""
              }`}
            >
              <div className="card-body ps-3 d-flex justify-content-center flex-column">
                <p className="text-nowrap">Tên: {voucher.name}</p>
                <p className="text-nowrap">{`Giảm giá: ${voucher.discount} %`}</p>
                <p className="font-sm text-nowrap">
                  Số lượng còn lại: {voucher.quantity}
                </p>
                <p className="">Mô tả: {voucher.description}</p>
              </div>
            </div>
          </div>
        ))}
      </div>
    </>
  );
};

export default Voucher;
