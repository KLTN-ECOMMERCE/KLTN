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
    deleteVoucher: builder.mutation({
      query(id) {
        return {
          url: `/voucher/deleteVoucher/${id}`,
          method: "DELETE",
        };
      },
      invalidatesTags: ["AdminVoucher"],
    }),
    createVoucher: builder.mutation({
      query(body) {
        return {
          url: "/voucher/createVoucher",
          method: "POST",
          body,
        };
      },
      invalidatesTags: ["AdminVoucher"],
    }),
  }),
});
export const {
  useGetVoucherQuery,
  useDeleteVoucherMutation,
  useCreateVoucherMutation,
} = voucherApi;
