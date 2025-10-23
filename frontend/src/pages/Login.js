import React from 'react';
import { Typography, Paper } from '@mui/material';

function Login() {
  return (
    <Paper elevation={3} sx={{ p: 4 }}>
      <Typography variant="h4" gutterBottom>
        ログイン
      </Typography>
      <Typography variant="body1" color="text.secondary">
        ログイン機能は現在開発中です。
      </Typography>
    </Paper>
  );
}

export default Login;
