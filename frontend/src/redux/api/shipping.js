import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";

export const shippingApi = createApi({
  reducerPath: "shippingApi",
  baseQuery: fetchBaseQuery({ baseUrl: "/api/v1" }),
  tagTypes: ["Shipping", "AdminShipping"],
  endpoints: (builder) => ({
    getShipping: builder.query({
      query: () => "/shipping/getShippingUnit",
      providesTags: ["Shipping"],
    }),
  }),
});

export const { useGetShippingQuery } = shippingApi;
