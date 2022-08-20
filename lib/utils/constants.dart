const String BASE_URL = "http://159.223.64.244:8069";


const String USER_NAME = "user_name";
const String USER_ID = "user_id";
const String USER_LANG = "user_lang";
const String USER_TZ = "user_tz";
const String USER_LOGIN = "user_login";
const String IMAGE = "image";
const String ISLOGGEDIN = "isloggedin";

const String USER_TYPE = "user_type";
const String USER_EMAIL = "email";
const String USER_PASSWORD = "password";

const String DEFAULT_DB = "Jumaiah";
const String DEFAULT_USER = "demo@jumaiah.com";
const String DEFAULT_USER2 = "admin";
const String DEFAULT_PASSWORD2 = "123456";
const String DEFAULT_PASSWORD3 = "bcool1984";

const String DEFAULT_PASSWORD = "bcool1984";
const String DEFAULT_DB2 = "Jumaiah";
const String DEFAULT_DB3 = "Jumaiah";
const String GUEST = "GUEST";
//jumaiah!@##@!

const String DEFAULT_IMG =
    "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8jVMWgOlFMvXKfnRCP3ss8+eHI/Hy1Op1Kxf//rXF+2+++43O44DABWt7QJ/SOSVlaDbQ/ZvA6UUZYwhkUggnU6HcrXdfve73z2wePHiAiWmhx9+eNQ///nPazp06FCeTqfBOd9cck2brS5Wvf3220+qqqrqQClF586dp06aNOn06urqjy3Lwssvv3z8imXLt6uL7rFr960alaeeePKM8rJ2aGhomD1hwoSJ/fr1+3cul0NtbW2fRx999JxWvOg8v8xzq3pD4vecbs758Qj9wgsvDFu+fPmAeDwOSqm+7d+33z527NhnMpnMB8XFxZgxY8Zxy5YsjW+r4W0FYdSgtrYWQ4cORXl5ObTWqKurGzBp0qSnwv3ee++97pdffvnksrKysvr6evTt2xdlZWWNWnZNNT6a4sknnzwzmUx2zGQy2G+//d674oorHurQocMmAGhoaOjz+OOPn/V9XdNjjz120BdffNEnFouhqKio4epr/m/KUUcd9ZzjOHPatWuH55577pRWkTOoObM9hsi27R/XQk+bNu0cQkhFOp3GXnvtNRcAzj3/vFk777zz10opZDKZntOmTdtqF0gMGq/S/IDc/j5dG9rCTaOUakopstksRowYcdFVV101PJPJVLdr1w6fffbZ0DPOOOO2efPmVVxwwQWPK6V6AsAuu+wy54477kh07NjxuUCYfau9x0svvTRkyeeLhwjGEY/H3z/mmGNeAIDRR4yakUqlkEgkMH369Inbcz2rV69ukQOPP/rYWfF4vKympgYjRox4DwAu+d2lr+60004bjDHYsGFDpxuu/+dZ23I5lFKhQKTXuntMkM1mfVfK/AiEXr58uT179uxDSkpKkM1m55500knTwm1HHXXUSw0NDUgmk5g+ffrJ24pytBULHUY+GGOoqanpeOzYMXMuvfTSKzdu3FhZWlracebMmReedtpp31RVVe1t2zYcx1l34403nt57t37Z6urqjqFy/9Z6rUcfffQcQkiF4zgYMGDAwl8dsP9aADj99NMfsm37AyEE1qxZ03Nbg9HWYM7sD7rNnTt3ZDKZhOd5c44//vjHw20jR458u66uDkVFRR2feOKJM7YVHaKUIhaLYfXq1X1mvPzKkBkvvzJkxowZg1555ZVBM2bMGPTyyy8PeeWll4e8+sqMQS889/zeuVwu/m2rdH2riZVHp047L1Xf0CeRSKBbt25rTp5wyvxw28knn/zQlClTThVCjFy3bl33B+67/+gz/vvMF3ZUIhqC78V6G2No2L2GbsOfr7j89uUrV/R76aWXxrdr164inU4jHo+jurq68p/XXf+bAw8+aGnwEnihvC8LihNtYUSWLot/8P7sQ4uLi1FdXT3/2GOPfT7ctuewoZuGDx/+wezZs4fHbbvi8UcfPefc8897qhU9l+rRo0ez1z916tTzPM/rxjlH3759l5wwftyScNuECRPuf/nll48WQhy8Zs2aPo8/+thBJ/7XSW9trXckjOGFl1667KVXXrnMdV2YQH7NKL8knud5BeXokskkXNf9cVyOZ555ZmJRURFSqRQOPvjgN/K37TlsqLv//vvPamhogGVZHR966KEL8QtAqCAa/h1+/sADD1y0xx57fFRdXY1EIoGNGzfWnn/++f/877PPeq4xtMWYDivMthTleOKJJ86sqanpp5TCTjvttHHSby4oMBKnnHLKFM/zPrZtG59//vmQGS+/MuS79IpvvvnmUclkEqlUCocccsjM/G0jDzqwZsCAAZ9ms1kAqJg2bVqLg0PGmM5ms4jH/eFUbW0tpJRwXRee5/nyaKkUgvi+r30dhFrD+jc/qIV+dOq0Q9euXdurvLwciUQCRx97zLNN9znllFMemjlz5uUdOnTAokWLhjw3/dl9jx07Zk5LIZ3vO+rQ9HxNSZL/UI3S38v0PyFEG2OgjIFs8n133HHHuHEnjn9/1apV/cYeO+aJa6655p/NvBEwW3E3nn322ZNLSkqQSqVw5JFHzmy6/fhxJ8ybPHnygqWLFw8lhFQ88MADF446cvTZzcTLtTIGoATKNC//decd/xm/bt267h06dEAymcRxxx33WNN9TjvttHsvuuiiS8rLy/Hee+8dPmvWrJ4jR45c1ZzLEYvFkEqlMGjQoOnDhw9/M51Ol1Dui8QTX2xeu65rM8Y8KaV45ZVXTshms0O+zaBwux/mk08+eQbnvNwYg2QyiVtuueV3N998MxWMu8YYaoyB53lWx44dw/rXFY888sgFzRFaSslDFf0fMibddDASKuZvTxWodDpdHLoFLY3mQx3optey2267ZW+44YbTb7nllr9MnTr13OYeenjeptrUADD1kSmHr1y5cvcOHTrAtm0sXLhw4Injxv/LdV2LMCpd17Xidsytr68vsW0bnHO89957h38876OKoXsV5l1orWlehVq1euUq0aNXz4L789RTT52WSCTKlFKIx+P4+9//fpXneTxflTWTySTat28fRmc63nPPPZeNHDnyN81YaM/zPBhjMHLkyFf+9L//c+e27vVHH300YsmSJUPCqgs/GKE/+ejjinCgIKVEfX09Zs2a9fv88g4Uvg8Uys+2b98e77///iEfzpnbZe9991nXXGQg8KV+EOHI4OEVMLd9+/abPM9DLBbDF1980ac151m8ePEgQggMISgqKaltjpR5kYotTMvoI0YtGH3EqHEt+Cs6r6Sbas7FsyyrPOyOlyxZMnH+fH/YQrn/EjnZHGzbRklRETzPg+d53e67775Lh+417E9Ne6/weVFKdVMyz3zt9QGLFi0aYvml4FBbW4u33nrrT8aYxjLLYSloYwyKk0lYnGPO7A8O/uzTBeUDBw+qbjrhJIRAKpVCawUhlVKCUtpseZDvldBTpkw5L51OdystLYUQYunQoUMXa/gW2bIsV0rJjdKUMaa11vTLL7/skcvl+ruu22XKlCnn7b3vPlc0Q4SwFvUPYqED37SAYAMGDPho+tNPo7i4GOvWret+7933jD3rnLOnt3SO+R9/0nH27NkHFxUVoa6hASNGjFjYnPvUkoVuDfzKtnqLKMdHH87r9MEHHxwURBuw0047zW7fvv2G0NJK7ed+MEI1pVRXVVZ2qqmp2deyLLz55ptHrl656oqmpM2rR06b8dXP8DyvSyKRACFk6Z577rnYcRzLsixXKcWllIJz7lFKted5/Ms1a/owxvps2rSp/5NPPnnmwMGD/tWMlQ59Yr4dvSoCH/2HI/SMGTOOa9euHRoaGjD+hBOeu/0/d/xxa/tffOFF1zz22GP9k8kkXnvttWNXr1z1t/ybm1/awbKsH63W9JFHHvnEzTfeeFUmk+ket+2Ka//+9+vbtWu36fhxJ7y7Rff34bxOl1566cMN6XT/0tJSyJqa2tGjRz/VktsQvKDb5fxRzjwNA0OwxYv91FNPnZbNZrsJIWDb9uJHHnnk0L679WvxSb/x+sz+55577rOWZfVZv379oKenPzPhsssue6DpS04Yg9SarV69moaRjuXLl9tvvPXmUUUlxahrqMfEiROn3njjjX/bWtvPO+vsW1588cU+xcXFeOaZZyZedfXf/tVcz8U530JIvsVeldFGl3B75ydaTeg7/j35pI0bN3YqKysD53zdqaeeOnlbx5x22mm3P/PMMxOFEN02bNgw6OGHH570l79eeWtTC21ZFhYuXLjng/c/cHSQZ0A1DDjnUmtNGWNeJpMpGjp06Pv77LPP19sZfdjCYvbdrV/23HPP/dcNN9xwdadOncocx+kzadKkJx955JGZw/cb8UZZWVlVQ0ND2cKFC4e98/asUel0uk95eTnWr1+Pgw8++KWJp506o6UBbnPfty2Esdqgmy14GV588cXxZWVlqK2txbhx417aGpkB4JDDDl08dOjQ2e+++26f0tJSPPbYY2flEzoMLwYTHQVhu+nTp0+sqanp36FDB2Qyma9POeWUbfq7EyZMmPz888+fJISoWLduXfc777zzhPPO2xwytCzLyeVyzQ7OtwbHcb7VvWw1oV9++eUThBAVrutijz32mL/vr/b7YlvH7LXP3l/vtdde786bN++UkpISvPzyyyfkE5pSqkngh82bN++M2bNnn+GXTKOQUjaWCQ6mkHHRRRf9eZ999tmuGtxKKTDGtnDG/ueKy29fv359t4cffviC0tLSZPv27Svmzp17yrvvv3eKlBKWZflJRiWliMfj+Oabb6qHDBny4Q03/uvUlmK6YfGh7XWfQmvkV7/afOyD9z9w9DfffNOlXbt2EEJ8PW7cuAdac74JEyb854033ji6Xbt25V988UWfxx9/fOSJJ544CwC4JVxu+eNOIYRs+vIkEgnU1dVh+PDhb7ZmscHIQw5eutdee707f8GCE8rKysqmTJlyXj6hPc+zmxZl2hYYYzqeTCCTyWzXS9DqOPRLL7005PXXXz8WAL766it9/PHHP9TaLzj99NNvr6qqcnK5HD7++OMRkydPHp8fOWhoaEBdXR0aGhqQy+X8QvKeB601pJQIR8gB0bd7lNDcoDDEbXdM/uNNN900sWfPnq9VVVVtcF0XjDHE4/FGV6iurm5DUVHR/Isvvvj/3nz7rdEtrW5Jp9MlNTU1qKmpQTqdLtmeNjY0NJTV1taipqYG+fm/d91112W5XK5i/fr16N+//4LDjjh8YWvON+a4sbP79+//ybp165DL5Spuuummq/KiE8nq6mrU19ejpqamfNWqVTQYHx0+d+7ckUopbNq0yTvppJPua237jz/++IeqqqqyuVwOH3744f7333//0XnfV5RKpVBdXY1MpnUlp+vr68uqqqpQV1cHz/PE926h23Xcqfr6m289vaysrDrn1MfPPn3zpMC2MPb442bf99B9v85kMkljDDp16vRVuO2qq/96US6TLWpuZinPiiutNcvlcvE999xzTqtuSKquzFMuCEuAUqwlW0kIOPOcs6efec7Z099++81+H3zwwUFff/11l2w2m4zFYtmOHTt+veeee8759a+P+XBb3/m/l//P7xsaGsqMMdhtt90WbM9D+Otf/3JJbW1tudaa5h971jn/fVMsFvt7Q0ND2aBBgz7cnnNee8O1Zy9atGiYbdvZfCt3xOjDp7drX1Ydi8WyhBAVvqBduuyy9tZbbz7Ftm0XAE4++eSZrf2uM84+6zki6ImMMS+Xy8W7devS2Hv//dprzvU8z/Y8jw8bNmx2a873v3/+w5/rajNFrqOtnj17bldR0DZZkuLUUyf857XXXjvPtm0UFxcvWLjw88GI8ItAm1v1fcO1153z+iuvjW1XXAaZ87Bb734Lo8f8y0GbqVN43113j73uuuuuTafTJWVlZRWEEEgpK88///zrosccEfrnB2HJ9ZWb+nXr1g0bN25ENptN//nPf77isNGjFkSPOSL0zw4l/nR0fSqV2rT77rsvP/fcc/814ZT/ei16xL8stKlB4duzZvZv3779hgF7tF7sJkJE6AgRdlhE2nYRIkJHiBAROkKEiNARIkSEjhAROkKEtoFWTax8vWjaod9UPnKebagm2lAB4cBwaYyhmkoe3cYI3xaW9FexaBL8UE0VVVQyJ6EokMqWVfXvN2Zah26ty/5rFRlra2vL169f3y1BhUe0ATdcwvgrqTWVInosEb4Dob1mCC0kc2zNCNI5j/fs3nqN6GhiJULkQ0eIEBE6QoSI0BEiRISOEBE6wk+FlctX2ACwdPGS5C/1HkyePHn8iSeeeH/+Z5dddtlfLr744qsjQv+MMG7cuAfHjBkzd/Z773ffe++9N2xLDb+tYtGiRcNmz559UP5nn3/++aB58+bt/6MQ+r777ju6U6dOXza37ZFHHjl8yJAhc1s6dvjw4W//9a9/vRgA7rnnnmMHDhw4r6V9Bw4cOO/WW289BQCuu+66c/r16/dZS/Xxfvvb317dr1+/zz7//PMtLN2ll1561bBhw95v7rjrrrvunL333vud5radffbZNx5wwAGvNrft/PPPv/6YY455tLltTz/99Ij+/ft/uq37OGbMmKmnnnrq5BG/2u+Ls84666Z999131i+R0LZtZ0qaCGDatu0UFRXV/yiEnjZt2jmVlZW7/O1vf9tCzDyVSpVUVVV1bOnYhoaGklQqVRLuu2nTpoqW9t20aVNFOp0uBoBcLhdfv379gEmTJj25ZMmSgmJE//73v0+66667LnNdd0A2W6jzAQCvvvrqsUuXLh00bdq0Q5tuy+Vy8aqqqi3asGLFCvHmm28eNX/+/H2ff/75vZtur6urK2tJOMV1XbuysnKbZe1OPfXUGf/vf/50JwDcdMvNVxxw4Mjlv0RCG2NYUyFHpRTbXtWkb0XoF198cdiyZcu+Gj9+/P977LHHtiBCoL3c4nnz1Y+EEN7WBPwYYzos0eC6rt2lSxfsuuuufU499dRGq/n666/3/8tf/nLbEUccEQ8lYPNxyy23TASAAw44IHnnnXf+oZn26GQyuYUlePTRR8+Jx+P99t9//5J77733kqbbhRBec1rOIVojPvnXv/714n333uedAbvv8enggYPmjT9h3IN33XXX2O9Cjptuuum0ww477PmBAwfO22OPPT6ZNGnS9S3tu3Tp0vgRRxzx7Ouvv95/a+ecPn36vqNHj36mT58+n/fu3XvJxIkT/9NcTxjy4+ijj378kEMOeXHMmDFTLrnkkqtmzJixzaqz31dFtO0m9H333HvJnoOHrJ82bdoNVZWbeuZLe4UNa6lOSPg2hgLkofroVi5Shy+H1prG4/E5kydPLqqsrNzlzDPPvG3ZsmX2hAkTZp5zzjn/Ovvss/eprKzcgkh33nnnH8aNG3fbddddV/rRRx+VvvHGG/2aWALaHDHvvffegeedd97Bl19+eenrr7/eae7cuZ2ati2RSKSaa3cymUxvawZ29OjRzzzwwANDJ0yYcPX1119/3AUXXPD7VatW8auvvvqmb/Mgp06deujgwYNvmDp1ap+jjjrq/htvvPGU3//+95c9/fTTexx22GHPN3dMfX192axZs47dWi95yy23TBw/fvx9u+666+wbb7xx3KWXXnrJnDlzepx88slvNrd/IpFIHXjggTOOP/74h/bcc885ixYtGjJu3Lh3rrjiiu2qW/ltRfC3K7Fo5cqVYtasWeLuu+9+AABOOOGEmXfdddcfLrjggifyCbI1HeB8QW+llNjagzfG0FD40LIst7a2tnz33XdPP/rooweOHTt27syZMy/s37//jGuvvfa6F154YRhjrEC9c/r06ftu3Lixcty4cU8OHDiwfujQocvuvvvuyw455JBz83uBpvppjzzyyOGpVKrjRRdd9Fbgyy+/4447/nefffa5KP+Gr169us+VV155KaVUSSkFpVTH4/HURx99tF8sFmtRJfTuu+8e+84773ScOXPmmcOHDw99x1XpdDpx279v33t7H+IHH3zQZeLEia8fddRRk1944YXf521aVl1dXX7NNdfcuWrVKtpUly/onbC1tv7jH/+4/je/+c21N998cyiy+fnAgQMXHnbYYS8/9NBDo0477bQCJdaDDz546cEHH5wv33Xr1VdffeHVV199469+9avXRo8e/YPKSmyXhb733nsvqaiocMYef9y6YJT+5JrVX/R5/tnn9t18QgK+lZrOFATKk34JNEJ1c3WzG8nm14mmAOA5rpWMJ9LBwHLdFX++/PfE4It77rp7DAC4OScObQoqsT54/wMX7zV02OqBAwfWA8CpEyZOef3V18bml/Q1SlOLiwJB8HvvvueyQw46eH74//gTxj3x6iszxuYXEhWM62w6U/LBBx+MfPvtt0e99957h7zxxhtHzpgxY+yaNWt6CyFkKITYFDNnzjx6zz33XJpHZgB+mYdvI/w+fPjwdf/65w1nfrFqNTlp/IkF9VuUJ3lxsqi+OZFJiwvPKI3wHjfFM089vX9dTW35maefUSDcOHLkyHVddun8zaoVK3dvTfuuuOKK23v37r34iSee2K4ozrcp+7ddFvqFF144qaam5qtePXo+JqXkQgiplCqbMmXK+ceMOXZOaLk8z7O35nKEXQnn3PM8r8U2SCl5aD045zLf8v/mogun/uaiC6fmWVrFOW90YcLyGYSQdT2793g7KF6TS6fTHadNm3b+oCGD/x62N3/w8d477/ZcsmTJoBUrVqiunbu8KISQjDFZV1fX5fHHHz/r8r9ccTsAeJ7He/Xq9fmMGTOO24IIzzwz4uyzz362JaXSXC4XF0LUN/cApfx22YuXXva7B379618/Nm7cuOsHDxx006efLbgUAG699daTTzzxxIdaGrwSQtDSWCAY9NrNvWSxWCznOE68te2rqKhY980333TaVq/d5H7gByP03XffPXbTpk0Vt95yy++KiorqPc+zY7FYdsWKFU9feeWVt73/7nvd99v/V1+4rmvbtp3dmssR+tA9evRYnslkipqrzfH5wkUlmUymqHfv3otD12Br7dNas/wSBlOnTj2voqLi63/84x+TPM8TAaGzM2fOPPbRRx896x/XXfv38Lj88zz44IMXdu7cee0//vGP/wmlbS3Lcp577rnlU6dOPS8kdKDp3GybPM8TTbWX89GpU6evPvnkk8HNDKjlt5EMDtF3t37ZBQs/u2jc8SdM2HvYXk+VlZXV7r///lNvvPmmx1oYoOvgOpqt8FpZWVkhpcTChQsHDBw8aG6T+023p63t27ffVFtbW74tI5fPk28zUGy1SX/wwQcvHDVq1PRxJ46fNfqoI+cfM+bYOYePOmLBpN9c8Fjfvn0X3XHHHX8KH77neVZLM1+UUh2SaNSRo+fvuuuuKydNmvRUfne+Ytly+4ILLniye/fuy4/89VEfhQTaVnccj8e/DgeFU6ZMOf+MM864ddSRo+cffewxHx47dsycI0aPWnDdP6//P6UUDycxmlqH6dOnT7z00kuvPHzUEQuOPvaYD48+9pgPjxg9asHtk//9p8rKyop7775nbHMvQjMDGrWVCZX7169fv9OECRP+0uRF4N9ltP/ZpwvKH7z/gaOz2exxa9euPf7dd9/97169enXfSg8ohBBwHCfRdNu8uR92euCBBy7eeeedcfnll1/zwnPP7/5dLGhlZWVFc9GkloIDQTWEH2ZQ+Oqrrw748MMP97/hhhvOaG77Weec/a8LL7zw0YeB862Ynd1QubHi2LFjPgjU26XjOPHx48ff/69//etvrvSEsDdHIu69/75fn3feec8cePBBy3r06LECAFavXt27c+fOX95z373HNHaP0uOpTLqopTZ6StKautry/nvsXn/bbbedIrWiF1/y20ea23fCqRMn33LbrZf//o9/uNdTUtSnGkoA4Morr7zUitnZCadOnNEsEU8c/8C111/397POOXu6Mpo2pFNFLVnohoaGdi219dBDD1187733/unqq68e07Vr10d23nlnQynVGzdu3Ml1XXvQoEHzEolEOigRvK2eiXLOZTqdLs7lconi4uKa/fbb760/X3H5rp9++um+11577bUPT3nk/A4dOmxQStHAKlMhhJPNZos0DK648i+33XjzTZW5XC4eltZYu3ZtzxEjRrxx9733HHPNNdfccPqZZ9y88847O0IIFwDqGurLpkybeu6M114dE7psQfkQHf4dtg0Avvnmm86EED1s2LD3CSFwXdfinEvGmPfVV191Ly0trW7i7hSF8xXbFR1pzVu2aNGikq+++qrbEUcc0aI07XPPPbf3scce+yEAPPvss/vG4/G0lJJTSrXjOPGuXbuuGjp0aOVuu+322dixYx+59tprC1RBX3nllUHLli0bAAB9+/Zd2HQ0vHjx4uSaNWt6bW2UHLZh7ty5nXK5XLy5QpAhnn/++b2POeaYD5cvX26vXLmy3+jRoxe89dZbfWKxWHb48OHrthaTHTt27JxPP/20vL6+vuyAAw5Yta37sTW8+eab/bLZbDx8+UOB96BL162x2JRSZVmW06FDhw2DBw/eQgZtxowZg6SUIuw1jDEstIqUUsU5lyGZQ4tZWlpak39t8+bNq9i0aVOF1pqGxwshvPC8WmvGOfeklEJrTS3LciilOpfLxS3LckKya62p53ki/Dt0d5LJZPrAAw9snFh65513elJK9a9+9asvvndCf5/o3Lnzmssuu+yK3/3udw8hQoSfMmz3XfC3v/3twpEjR75KCMGYMWOmRbf+p0WvXr2WTJ48efydd955Qr9+/T5rKcT4bTFx4sT/HHLIIS/+2Nf1o63YXrt2bU/btrMPPvjg6F69enkRpX5a9O7de3GHDh02MMZ0z549l7YUYvy2qKioWB+LxTI/9nVFi2QjRC5HhAgRoSNEiAgdIUJE6AgRoSNEiAgdIUJE6AgRIkJHiBAROkJE6AgRIkJHiBAROkKEiNARIkSEjvCLwv8fAArih4RpMWBqAAAAAElFTkSuQmCC";

const String EMPTY = "assets/animations/empty.json";
const String SERVER = "assets/animations/server.json";
const String UNKNOWN = "assets/animations/unknown.json";
const String NOINTERNERT = "assets/animations/no_internet.json";
const String TIMEOUT = "assets/animations/timeout.json";
const String LOADING = "assets/animations/loading.json";
