<template>
    <b-table-simple caption-top responsive>
        <caption>
            Condiciones meteorológicas
        </caption>
        <b-thead>
            <b-tr>
                <b-th>1</b-th>
                <b-th>2</b-th>
                <b-th>3</b-th>
                <b-th>4</b-th>
                <b-th>5</b-th>
                <b-th>6</b-th>
                <b-th>7</b-th>
                <b-th>8</b-th>
                <b-th>9</b-th>
                <b-th>10</b-th>
                <b-th>11</b-th>
                <b-th>12</b-th>
                <b-th>13</b-th>
                <b-th>14</b-th>
                <b-th>15</b-th>
                <b-th>16</b-th>
                <b-th>17</b-th>
                <b-th>18</b-th>
                <b-th>19</b-th>
                <b-th>20</b-th>
                <b-th>21</b-th>
                <b-th>22</b-th>
                <b-th>23</b-th>
                <b-th>24</b-th>
            </b-tr>
        </b-thead>
        <b-tbody>
            <b-tr>
                <b-td v-for="(c, i) in datos" :key="i">
                    <b-icon
                        :icon="
                            c.clima == 'd '
                                ? 'sun'
                                : c.clima == 'n '
                                ? 'cloud'
                                : 'cloud-download-fill'
                        "
                    ></b-icon>
                </b-td>
            </b-tr>
        </b-tbody>
    </b-table-simple>
</template>

<script>
export default {
    props: ["datos"],
    data() {
        return {
            items: [{ 1: '<b-icon icon="arrow-up"></b-icon>' }],
        };
    },
};
</script>

<style></style>
