import React from 'react';
import { Typography, Paper } from '@mui/material';

function Orders() {
  return (
    <Paper elevation={3} sx={{ p: 4 }}>
      <Typography variant="h4" gutterBottom>
        注文一覧
      </Typography>
      <Typography variant="body1" color="text.secondary">
        注文管理機能は現在開発中です。
      </Typography>
    </Paper>
  );
}

export default Orders;
