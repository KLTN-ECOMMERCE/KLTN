import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";

export const voucherApi = createApi({
  reducerPath: "vouchertApi",
  baseQuery: fetchBaseQuery({ baseUrl: "/api/v1" }),
  tagTypes: ["Voucher", "AdminVoucher"],
  endpoints: (builder) => ({
    getVoucher: builder.query({
      query: () => "/voucher/getAllVoucher",
      providesTags: ["AdminVoucher"],
    }),
  }),
});
export const { useGetVoucherQuery } = voucherApi;
