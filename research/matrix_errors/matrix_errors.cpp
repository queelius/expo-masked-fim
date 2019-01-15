#include <iostream>
#include <fstream>
#include <functional>
#include <random>

template <int N, typename T>
void get_matrix(std::istream& in, T a[N][N])
{
    for (int i = 0; i < N; ++i)
        for (int j = 0; j < N; ++j)
            if (!(in >> a[i][j]))
            {
                std::cerr << "[get_matrix] invalid input stream\n";
                return;
            }
}

template <int N, typename T>
void print_matrix(T a[N][N], std::ostream& out = std::cout)
{
    for (int i = 0; i < N; ++i)
    {
        for (int j = 0; j < N; ++j)
            out << a[i][j] << '\t';
        out << '\n';
    }
}

template <int N, typename T>
T sum_squared_error(T b[N][N], T a[N][N])
{
    T sse = 0;
    for (int i = 0; i < N; ++i)
        for (int j = 0; j < N; ++j)
            sse += (b[i][j] - a[i][j]) * (b[i][j] - a[i][j]);
    return sse;
}

template <int N, typename T>
T mean_squared_error(T a[N][N], T b[N][N])
{
    return sum_squared_error<N, T>(a, b) / (N * N);
}

template <int N, typename T>
T frobenius_norm(T a[N][N])
{
    T result = 0;
    for (int i = 0; i < N; ++i)
        for (int j = 0; j < N; ++j)
            result += a[i][j] * a[i][j];
    return std::sqrt(result);
}

template <int N, typename T>
T one_norm(T a[N][N])
{
    T max_col_sum = 0;
    for (int j = 0; j < N; ++j)
    {
        T col_sum = 0;
        for (int i = 0; i < N; ++i)
            col_sum += std::abs(a[i][j]);
        if (col_sum > max_col_sum)
            max_col_sum = col_sum;
    }
    return max_col_sum;
}

template <int N, typename T>
void difference(T a[N][N], T b[N][N], T c[N][N])
{
    for (int i = 0; i < N ; ++i)
        for (int j = 0; j < N; ++j)
            c[i][j] = a[i][j] - b[i][j];
}

template <int N, typename T>
void sum(T a[N][N], T b[N][N], T c[N][N])
{
    for (int i = 0; i < N ; ++i)
        for (int j = 0; j < N; ++j)
            c[i][j] = a[i][j] + b[i][j];
}

template <int N, typename T>
void scalar_product(T scalar, T a[N][N], T c[N][N])
{
    for (int i = 0; i < N ; ++i)
        for (int j = 0; j < N; ++j)
            c[i][j] = scalar * a[i][j];
}

template <int N, typename T>
T frobenius_norm_relative_error(T tru[N][N], T est[N][N])
{
    T delta[N][N];
    difference<N, T>(est, tru, delta);
    return frobenius_norm<N, T>(delta) / frobenius_norm<N, T>(tru);
}

template <int N, typename T>
T frobenius_norm_error(T tru[N][N], T est[N][N])
{
    T delta[N][N];
    difference<N, T>(est, tru, delta);
    return frobenius_norm<N, T>(delta);
}

template <int N, typename T>
T one_norm_error(T tru[N][N], T est[N][N])
{
    T delta[N][N];
    difference<N, T>(est, tru, delta);
    return one_norm<N, T>(delta);
}

template <int N, typename T>
T one_norm_relative_error(T tru[N][N], T est[N][N])
{
    T delta[N][N];
    difference<N, T>(est, tru, delta);
    return one_norm<N, T>(delta) / one_norm<N, T>(tru);
}

void matrices_by_10_start_10_end_350()
{
    auto f = std::ifstream("matrices_by_10_start_10_end_350.dat");
    auto out = std::ofstream("error{frob}_by_10_start_10_end_350.dat");

    std::cout.precision(10);

    double true_cov[3][3];
    double asym_cov[3][3];

    int n = 10;
    while (f)
    {
        get_matrix<3,double>(f, asym_cov);
        get_matrix<3,double>(f, true_cov);

        out << n << '\t' << frobenius_norm_error<3, double>(true_cov, asym_cov) << std::endl;
        n += 10;
    }
}

void matrices_by_100_start_400_end_1000()
{
    auto f = std::ifstream("matrices_by_100_start_400_end_1000.dat");
    auto out = std::ofstream("error{frob}_by_100_start_400_end_1000.dat");

    std::cout.precision(10);

    double cov[3][3];
    double a[3][3];

    int n = 400;
    while (f)
    {
        get_matrix<3, double>(f, a);
        get_matrix<3, double>(f, cov);
        out << n << '\t' << frobenius_norm_error<3, double>(cov, a) << std::endl;
        n += 100;
    }
}

void matrices_by_500_start_1500_end_5000()
{
    auto f = std::ifstream("matrices_by_100_start_400_end_1000.dat");
    auto out = std::ofstream("error{frob}_by_100_start_400_end_1000.dat");

    std::cout.precision(10);

    double cov[3][3];
    double a[3][3];

    int n = 400;
    while (f)
    {
        get_matrix<3, double>(f, a);
        get_matrix<3, double>(f, cov);
        out << n << '\t' << frobenius_norm_error<3, double>(cov, a) << std::endl;
        n += 100;
    }
}

void rewrite_data(std::istream& in, std::ostream& out)
{
    while (in)
    {
        int N;
        in >> N;

        double bias[3];
        in >> bias[0] >> bias[1] >> bias[2];

        double abs_error_true_asym;
        in >> abs_error_true_asym;

        double rel_error_true_asym;
        in >> rel_error_true_asym;

        double abs_error_mu;
        in >> abs_error_mu;

        double abs_error_var;
        in >> abs_error_var;

        double rel_error_mu;
        in >> rel_error_mu;

        double rel_error_var;
        in >> rel_error_var;

        double prop_true_reg;
        in >> prop_true_reg;

        double prop_reg;
        in >> prop_reg;

        double ci_prop[3];
        in >> ci_prop[0] >> ci_prop[1] >> ci_prop[2];

        out << N << '\t'
            << abs_error_true_asym << '\t' << rel_error_true_asym << '\t'
            << abs_error_mu << '\t' << abs_error_var << '\t'
            << rel_error_mu << '\t' << rel_error_var << '\t'
            << prop_reg << '\t'
            << prop_true_reg << '\n';
    }
}

void main()
{
    std::random_device r; 
    std::seed_seq seeds{r(), r(), r(), r(), r(), r(), r(), r()};
    std::mt19937 eng(seeds);
    std::uniform_real_distribution<double> u(0., 1.);
    auto u0_1 = [u, &eng](void) -> double { return u(eng); };

    auto X = chisquared<double>(9., u0_1);
    std::vector<double> Xs;
    for (size_t i = 0; i < 1000; ++i)
    {
        Xs.push_back(X());
    }


    //rewrite_data(std::ifstream("data"), std::ofstream("dist.dat"));
}